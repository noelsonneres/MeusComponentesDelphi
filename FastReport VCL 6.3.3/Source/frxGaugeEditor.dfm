object frxGaugeEditorForm: TfrxGaugeEditorForm
  Tag = 6530
  Left = 376
  Top = 169
  BorderStyle = bsDialog
  Caption = 'Gauge Editor'
  ClientHeight = 446
  ClientWidth = 579
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -10
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  DesignSize = (
    579
    446)
  PixelsPerInch = 96
  TextHeight = 12
  object SamplePaintBox: TPaintBox
    Left = 6
    Top = 224
    Width = 169
    Height = 169
    Anchors = [akLeft, akBottom]
    OnPaint = SamplePaintBoxPaint
  end
  object CancelButton: TButton
    Tag = 2
    Left = 499
    Top = 416
    Width = 73
    Height = 24
    Anchors = [akRight, akBottom]
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 4
  end
  object OkButton: TButton
    Tag = 1
    Left = 421
    Top = 416
    Width = 73
    Height = 24
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 3
  end
  object FillButton: TButton
    Tag = 6383
    Left = 6
    Top = 6
    Width = 78
    Height = 20
    Caption = 'Fill...'
    TabOrder = 0
    OnClick = FillButtonClick
  end
  object FrameButton: TButton
    Tag = 5103
    Left = 6
    Top = 33
    Width = 78
    Height = 20
    Caption = 'Frame...'
    TabOrder = 1
    OnClick = FrameButtonClick
  end
  object GaugeOptionsPageControl: TPageControl
    Left = 188
    Top = 7
    Width = 384
    Height = 400
    ActivePage = GeneralTabSheet
    Anchors = [akTop, akRight, akBottom]
    TabOrder = 2
    object GeneralTabSheet: TTabSheet
      Tag = 6380
      Caption = 'General'
      object GaugeKindLabel: TLabel
        Tag = 6534
        Left = 12
        Top = 17
        Width = 56
        Height = 12
        Caption = 'Gauge Kind:'
      end
      object MinimumLabel: TLabel
        Tag = 6536
        Left = 12
        Top = 44
        Width = 44
        Height = 12
        Caption = 'Minimum:'
      end
      object MaximumLabel: TLabel
        Tag = 6537
        Left = 12
        Top = 71
        Width = 46
        Height = 12
        Caption = 'Maximum:'
      end
      object MajorStepLabel: TLabel
        Tag = 6539
        Left = 12
        Top = 179
        Width = 53
        Height = 12
        Caption = 'Major Step:'
      end
      object CurrentValueLabel: TLabel
        Tag = 6538
        Left = 12
        Top = 98
        Width = 28
        Height = 12
        Caption = 'Value:'
      end
      object MinorStepLabel: TLabel
        Tag = 6540
        Left = 12
        Top = 206
        Width = 53
        Height = 12
        Caption = 'Minor Step:'
      end
      object StartValueLabel: TLabel
        Tag = 6552
        Left = 198
        Top = 98
        Width = 52
        Height = 12
        Caption = 'Start Value:'
      end
      object EndValueLabel: TLabel
        Tag = 6553
        Left = 12
        Top = 125
        Width = 49
        Height = 12
        Caption = 'End Value:'
      end
      object AngleLabel: TLabel
        Tag = 6554
        Left = 12
        Top = 152
        Width = 30
        Height = 12
        Caption = 'Angle:'
      end
      object GaugeKindComboBox: TComboBox
        Left = 126
        Top = 14
        Width = 229
        Height = 20
        Style = csDropDownList
        ItemHeight = 12
        TabOrder = 0
        OnChange = ComboBoxChange
      end
      object MinimumEdit: TEdit
        Left = 126
        Top = 41
        Width = 57
        Height = 24
        TabOrder = 1
        Text = '0'
        OnChange = EditChange
        OnKeyPress = EditFloatKeyPress
      end
      object MaximumEdit: TEdit
        Left = 126
        Top = 68
        Width = 57
        Height = 24
        TabOrder = 2
        Text = '0'
        OnChange = EditChange
        OnKeyPress = EditFloatKeyPress
      end
      object MajorStepEdit: TEdit
        Left = 126
        Top = 177
        Width = 57
        Height = 24
        TabOrder = 6
        Text = '0'
        OnChange = EditChange
        OnKeyPress = EditFloatKeyPress
      end
      object CurrentValueEdit: TEdit
        Left = 126
        Top = 95
        Width = 57
        Height = 24
        TabOrder = 3
        Text = '0'
        OnChange = EditChange
        OnKeyPress = EditFloatKeyPress
      end
      object MinorStepEdit: TEdit
        Left = 126
        Top = 204
        Width = 57
        Height = 24
        TabOrder = 7
        Text = '0'
        OnChange = EditChange
        OnKeyPress = EditFloatKeyPress
      end
      object MarginsGroupBox: TGroupBox
        Tag = 6541
        Left = 12
        Top = 233
        Width = 352
        Height = 133
        Caption = 'Margins'
        TabOrder = 8
        object TopLabel: TLabel
          Tag = 6543
          Left = 12
          Top = 50
          Width = 22
          Height = 12
          Caption = 'Top:'
        end
        object LeftLabel: TLabel
          Tag = 6542
          Left = 12
          Top = 23
          Width = 20
          Height = 12
          Caption = 'Left:'
        end
        object BottomLabel: TLabel
          Tag = 6545
          Left = 12
          Top = 104
          Width = 36
          Height = 12
          Caption = 'Bottom:'
        end
        object RightLabel: TLabel
          Tag = 6544
          Left = 12
          Top = 77
          Width = 27
          Height = 12
          Caption = 'Right:'
        end
        object LeftEdit: TEdit
          Left = 114
          Top = 20
          Width = 42
          Height = 24
          TabOrder = 0
          Text = '0'
          OnChange = SpinEditChange
          OnKeyPress = EditIntKeyPress
        end
        object LeftUpDown: TUpDown
          Left = 156
          Top = 20
          Width = 15
          Height = 18
          Associate = LeftEdit
          Max = 10000
          TabOrder = 1
        end
        object TopEdit: TEdit
          Left = 114
          Top = 47
          Width = 42
          Height = 24
          TabOrder = 2
          Text = '0'
          OnChange = SpinEditChange
          OnKeyPress = EditIntKeyPress
        end
        object TopUpDown: TUpDown
          Left = 156
          Top = 47
          Width = 15
          Height = 18
          Associate = TopEdit
          Max = 10000
          TabOrder = 3
        end
        object RightEdit: TEdit
          Left = 114
          Top = 74
          Width = 42
          Height = 24
          TabOrder = 4
          Text = '0'
          OnChange = SpinEditChange
          OnKeyPress = EditIntKeyPress
        end
        object RightUpDown: TUpDown
          Left = 156
          Top = 74
          Width = 15
          Height = 18
          Associate = RightEdit
          Max = 10000
          TabOrder = 5
        end
        object BottomEdit: TEdit
          Left = 114
          Top = 101
          Width = 42
          Height = 24
          TabOrder = 6
          Text = '0'
          OnChange = SpinEditChange
          OnKeyPress = EditIntKeyPress
        end
        object BottomUpDown: TUpDown
          Left = 156
          Top = 101
          Width = 15
          Height = 18
          Associate = BottomEdit
          Max = 10000
          TabOrder = 7
        end
      end
      object StartValueEdit: TEdit
        Left = 312
        Top = 95
        Width = 57
        Height = 24
        TabOrder = 4
        Text = '0'
        OnChange = EditChange
        OnKeyPress = EditFloatKeyPress
      end
      object EndValueEdit: TEdit
        Left = 126
        Top = 122
        Width = 57
        Height = 24
        TabOrder = 5
        Text = '0'
        OnChange = EditChange
        OnKeyPress = EditFloatKeyPress
      end
      object AngleUpDown: TUpDown
        Left = 168
        Top = 149
        Width = 15
        Height = 18
        Associate = AngleEdit
        Max = 360
        TabOrder = 9
      end
      object AngleEdit: TEdit
        Left = 126
        Top = 149
        Width = 42
        Height = 24
        TabOrder = 10
        Text = '0'
        OnChange = SpinEditChange
        OnKeyPress = EditIntKeyPress
      end
    end
    object MajorScaleTabSheet: TTabSheet
      Tag = 6531
      Caption = 'Major Scale'
      ImageIndex = 1
      DesignSize = (
        376
        373)
      object MajorScaleFormatLabel: TLabel
        Tag = 6399
        Left = 12
        Top = 98
        Width = 36
        Height = 12
        Caption = 'Format:'
      end
      object MajorScaleFontLabel: TLabel
        Left = 126
        Top = 128
        Width = 32
        Height = 12
        Anchors = [akTop, akRight]
        Caption = 'Sample'
      end
      object MajorScaleVisibleCheckBox: TCheckBox
        Tag = 6391
        Left = 12
        Top = 17
        Width = 181
        Height = 16
        Caption = 'Visible'
        TabOrder = 0
        OnClick = CheckBoxClick
      end
      object MajorScaleVisibleDigitsCheckBox: TCheckBox
        Tag = 6548
        Left = 12
        Top = 44
        Width = 181
        Height = 16
        Caption = 'Visible Digits'
        TabOrder = 1
        OnClick = CheckBoxClick
      end
      object MajorScaleBilateralCheckBox: TCheckBox
        Tag = 6549
        Left = 12
        Top = 71
        Width = 181
        Height = 16
        Caption = 'Bilateral'
        TabOrder = 2
        OnClick = CheckBoxClick
      end
      object MajorScaleFormatEdit: TEdit
        Left = 126
        Top = 95
        Width = 57
        Height = 24
        TabOrder = 3
        OnChange = EditChange
      end
      object MajorScaleFontButton: TButton
        Tag = 6397
        Left = 12
        Top = 125
        Width = 78
        Height = 20
        Anchors = [akTop, akRight]
        Caption = 'Font...'
        TabOrder = 4
        OnClick = FontButtonClick
      end
      object MajorScaleTicksGroupBox: TGroupBox
        Tag = 6550
        Left = 12
        Top = 152
        Width = 352
        Height = 107
        Caption = 'Ticks'
        TabOrder = 5
        object MajorScaleTicksWidthLabel: TLabel
          Tag = 6546
          Left = 12
          Top = 50
          Width = 31
          Height = 12
          Caption = 'Width:'
        end
        object MajorScaleTicksLengthLabel: TLabel
          Tag = 6551
          Left = 12
          Top = 23
          Width = 35
          Height = 12
          Caption = 'Length:'
        end
        object MajorScaleTicksColorLabel: TLabel
          Tag = 6392
          Left = 12
          Top = 77
          Width = 29
          Height = 12
          Caption = 'Color:'
        end
        object MajorScaleTicksColorColorBox: TColorBox
          Left = 114
          Top = 77
          Width = 114
          Height = 22
          ItemHeight = 16
          TabOrder = 4
          OnChange = ColorBoxChange
        end
        object MajorScaleTicksWidthEdit: TEdit
          Left = 114
          Top = 47
          Width = 42
          Height = 24
          TabOrder = 2
          Text = '0'
          OnChange = SpinEditChange
          OnKeyPress = EditIntKeyPress
        end
        object MajorScaleTicksWidthUpDown: TUpDown
          Left = 156
          Top = 47
          Width = 15
          Height = 18
          Associate = MajorScaleTicksWidthEdit
          Max = 10000
          TabOrder = 3
        end
        object MajorScaleTicksLengthUpDown: TUpDown
          Left = 156
          Top = 20
          Width = 15
          Height = 18
          Associate = MajorScaleTicksLengthEdit
          Max = 10000
          TabOrder = 1
        end
        object MajorScaleTicksLengthEdit: TEdit
          Left = 114
          Top = 20
          Width = 42
          Height = 24
          TabOrder = 0
          Text = '0'
          OnChange = SpinEditChange
          OnKeyPress = EditIntKeyPress
        end
      end
    end
    object MinorScaleTabSheet: TTabSheet
      Tag = 6532
      Caption = 'Minor Scale'
      ImageIndex = 2
      DesignSize = (
        376
        373)
      object MinorScaleFormatLabel: TLabel
        Tag = 6399
        Left = 12
        Top = 98
        Width = 36
        Height = 12
        Caption = 'Format:'
      end
      object MinorScaleFontLabel: TLabel
        Left = 126
        Top = 128
        Width = 32
        Height = 12
        Anchors = [akTop, akRight]
        Caption = 'Sample'
      end
      object MinorScaleVisibleCheckBox: TCheckBox
        Tag = 6391
        Left = 12
        Top = 17
        Width = 181
        Height = 16
        Caption = 'Visible'
        TabOrder = 0
        OnClick = CheckBoxClick
      end
      object MinorScaleVisibleDigitsCheckBox: TCheckBox
        Tag = 6548
        Left = 12
        Top = 44
        Width = 181
        Height = 16
        Caption = 'Visible Digits'
        TabOrder = 1
        OnClick = CheckBoxClick
      end
      object MinorScaleBilateralCheckBox: TCheckBox
        Tag = 6549
        Left = 12
        Top = 71
        Width = 181
        Height = 16
        Caption = 'Bilateral'
        TabOrder = 2
        OnClick = CheckBoxClick
      end
      object MinorScaleFormatEdit: TEdit
        Left = 126
        Top = 95
        Width = 57
        Height = 24
        TabOrder = 3
        OnChange = EditChange
      end
      object MinorScaleFontButton: TButton
        Tag = 6397
        Left = 12
        Top = 125
        Width = 78
        Height = 20
        Anchors = [akTop, akRight]
        Caption = 'Font...'
        TabOrder = 4
        OnClick = FontButtonClick
      end
      object MinorScaleTicksGroupBox: TGroupBox
        Tag = 6550
        Left = 12
        Top = 152
        Width = 352
        Height = 107
        Caption = 'Ticks'
        TabOrder = 5
        object MinorScaleTicksWidthLabel: TLabel
          Tag = 6546
          Left = 12
          Top = 50
          Width = 31
          Height = 12
          Caption = 'Width:'
        end
        object MinorScaleTicksLengthLabel: TLabel
          Tag = 6551
          Left = 12
          Top = 23
          Width = 35
          Height = 12
          Caption = 'Length:'
        end
        object MinorScaleTicksColorLabel: TLabel
          Tag = 6392
          Left = 12
          Top = 77
          Width = 29
          Height = 12
          Caption = 'Color:'
        end
        object MinorScaleTicksColorColorBox: TColorBox
          Left = 114
          Top = 77
          Width = 114
          Height = 22
          ItemHeight = 16
          TabOrder = 4
          OnChange = ColorBoxChange
        end
        object MinorScaleTicksLengthEdit: TEdit
          Left = 114
          Top = 20
          Width = 42
          Height = 24
          TabOrder = 0
          Text = '0'
          OnChange = SpinEditChange
          OnKeyPress = EditIntKeyPress
        end
        object MinorScaleTicksLengthUpDown: TUpDown
          Left = 156
          Top = 20
          Width = 15
          Height = 18
          Associate = MinorScaleTicksLengthEdit
          Max = 10000
          TabOrder = 1
        end
        object MinorScaleTicksWidthUpDown: TUpDown
          Left = 156
          Top = 47
          Width = 15
          Height = 18
          Associate = MinorScaleTicksWidthEdit
          Max = 10000
          TabOrder = 3
        end
        object MinorScaleTicksWidthEdit: TEdit
          Left = 114
          Top = 47
          Width = 42
          Height = 24
          TabOrder = 2
          Text = '0'
          OnChange = SpinEditChange
          OnKeyPress = EditIntKeyPress
        end
      end
    end
    object PointerTabSheet: TTabSheet
      Tag = 6533
      Caption = 'Pointer'
      ImageIndex = 3
      object PointerKindLabel: TLabel
        Tag = 6535
        Left = 12
        Top = 17
        Width = 59
        Height = 12
        Caption = 'Pointer Kind:'
      end
      object BorderWidthLabel: TLabel
        Tag = 6393
        Left = 12
        Top = 44
        Width = 63
        Height = 12
        Caption = 'Border width:'
      end
      object BorderColorLabel: TLabel
        Tag = 6392
        Left = 12
        Top = 71
        Width = 61
        Height = 12
        Caption = 'Border color:'
      end
      object ColorLabel: TLabel
        Tag = 6111
        Left = 12
        Top = 152
        Width = 29
        Height = 12
        Caption = 'Color:'
      end
      object WidthLabel: TLabel
        Tag = 6546
        Left = 12
        Top = 98
        Width = 31
        Height = 12
        Caption = 'Width:'
      end
      object HeightLabel: TLabel
        Tag = 6547
        Left = 12
        Top = 125
        Width = 33
        Height = 12
        Caption = 'Height:'
      end
      object PointerKindComboBox: TComboBox
        Left = 126
        Top = 14
        Width = 229
        Height = 24
        Style = csDropDownList
        ItemHeight = 0
        TabOrder = 0
        OnChange = ComboBoxChange
      end
      object BorderColorColorBox: TColorBox
        Left = 126
        Top = 71
        Width = 114
        Height = 22
        ItemHeight = 16
        TabOrder = 3
        OnChange = ColorBoxChange
      end
      object ColorColorBox: TColorBox
        Left = 126
        Top = 152
        Width = 114
        Height = 22
        ItemHeight = 16
        TabOrder = 8
        OnChange = ColorBoxChange
      end
      object WidthEdit: TEdit
        Left = 126
        Top = 95
        Width = 42
        Height = 24
        TabOrder = 4
        Text = '0'
        OnChange = SpinEditChange
        OnKeyPress = EditIntKeyPress
      end
      object WidthUpDown: TUpDown
        Left = 168
        Top = 95
        Width = 15
        Height = 18
        Associate = WidthEdit
        Max = 10000
        TabOrder = 5
      end
      object HeightUpDown: TUpDown
        Left = 168
        Top = 122
        Width = 15
        Height = 18
        Associate = HeightEdit
        Max = 10000
        TabOrder = 7
      end
      object HeightEdit: TEdit
        Left = 126
        Top = 122
        Width = 42
        Height = 24
        TabOrder = 6
        Text = '0'
        OnChange = SpinEditChange
        OnKeyPress = EditIntKeyPress
      end
      object BorderWidthEdit: TEdit
        Left = 126
        Top = 41
        Width = 42
        Height = 24
        TabOrder = 1
        Text = '0'
        OnChange = SpinEditChange
        OnKeyPress = EditIntKeyPress
      end
      object BorderWidthUpDown: TUpDown
        Left = 168
        Top = 41
        Width = 15
        Height = 18
        Associate = BorderWidthEdit
        Max = 10000
        TabOrder = 2
      end
    end
  end
  object FontDialog: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Left = 180
    Top = 4
  end
end
