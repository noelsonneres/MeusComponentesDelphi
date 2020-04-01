object frxMapEditorForm: TfrxMapEditorForm
  Tag = 6370
  Left = 309
  Top = 237
  BorderStyle = bsDialog
  Caption = 'Map Editor'
  ClientHeight = 707
  ClientWidth = 1142
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  DesignSize = (
    1142
    707)
  PixelsPerInch = 96
  TextHeight = 13
  object LayerOptionsPageControl: TPageControl
    Left = 741
    Top = 6
    Width = 392
    Height = 659
    ActivePage = DataTabSheet
    MultiLine = True
    TabOrder = 2
    object DataTabSheet: TTabSheet
      Tag = 6410
      Caption = 'Data'
      object DataSourceLabel: TLabel
        Tag = 6411
        Left = 12
        Top = 17
        Width = 46
        Height = 13
        Caption = 'Data Set:'
      end
      object FilterLabel: TLabel
        Tag = 6412
        Left = 12
        Top = 44
        Width = 28
        Height = 13
        Caption = 'Filter:'
      end
      object ZoomPolygonLabel: TLabel
        Tag = 6413
        Left = 12
        Top = 394
        Width = 90
        Height = 13
        Caption = 'Zoom the polygon:'
      end
      object DatasetComboBox: TComboBox
        Left = 128
        Top = 11
        Width = 234
        Height = 21
        Style = csDropDownList
        TabOrder = 0
        OnChange = ComboBoxChange
      end
      object FilterComboEdit: TfrxComboEdit
        Left = 128
        Top = 41
        Width = 234
        Height = 21
        Style = csSimple
        TabOrder = 1
        OnChange = ComboEditChange
        OnButtonClick = ComboEditButtonClick
      end
      object SpatialDataMapLayerGroupBox: TGroupBox
        Tag = 6417
        Left = 12
        Top = 170
        Width = 362
        Height = 85
        Caption = 'Spatial data'
        TabOrder = 3
        object ColumnLabel: TLabel
          Tag = 6418
          Left = 12
          Top = 24
          Width = 39
          Height = 13
          Caption = 'Column:'
        end
        object SpatialValueLabel: TLabel
          Tag = 6415
          Left = 12
          Top = 52
          Width = 30
          Height = 13
          Caption = 'Value:'
        end
        object SpatialValueComboEdit: TfrxComboEdit
          Left = 116
          Top = 49
          Width = 233
          Height = 21
          Style = csSimple
          TabOrder = 1
          OnChange = ComboEditChange
          OnButtonClick = ComboEditButtonClick
        end
        object SpatialColumnComboBox: TComboBox
          Left = 116
          Top = 21
          Width = 233
          Height = 21
          Style = csDropDownList
          TabOrder = 0
          OnChange = ComboBoxChange
        end
      end
      object AnalyticalDataGroupBox: TGroupBox
        Tag = 6414
        Left = 12
        Top = 70
        Width = 362
        Height = 85
        Caption = 'Analytical data'
        TabOrder = 2
        object AnalyticalValueLabel: TLabel
          Tag = 6415
          Left = 12
          Top = 24
          Width = 30
          Height = 13
          Caption = 'Value:'
        end
        object FunctionLabel: TLabel
          Tag = 6416
          Left = 12
          Top = 52
          Width = 45
          Height = 13
          Caption = 'Function:'
        end
        object FunctionComboBox: TComboBox
          Left = 116
          Top = 49
          Width = 233
          Height = 21
          Style = csDropDownList
          TabOrder = 1
          OnChange = ComboBoxChange
        end
        object AnalyticalValueComboEdit: TfrxComboEdit
          Left = 116
          Top = 21
          Width = 233
          Height = 21
          Style = csSimple
          TabOrder = 0
          OnChange = ComboEditChange
          OnButtonClick = ComboEditButtonClick
        end
      end
      object SpatialDataAppLayerGroupBox: TGroupBox
        Tag = 6417
        Left = 12
        Top = 265
        Width = 362
        Height = 114
        Caption = 'Spatial data'
        TabOrder = 5
        object LatitudeLabel: TLabel
          Tag = 6419
          Left = 12
          Top = 24
          Width = 43
          Height = 13
          Caption = 'Latitude:'
        end
        object LongitudeLabel: TLabel
          Tag = 6420
          Left = 12
          Top = 52
          Width = 51
          Height = 13
          Caption = 'Longitude:'
        end
        object LabelLabel: TLabel
          Tag = 6421
          Left = 12
          Top = 80
          Width = 29
          Height = 13
          Caption = 'Label:'
        end
        object LatitudeComboEdit: TfrxComboEdit
          Left = 116
          Top = 21
          Width = 233
          Height = 21
          Style = csSimple
          TabOrder = 0
          OnChange = ComboEditChange
          OnButtonClick = ComboEditButtonClick
        end
        object LongitudeComboEdit: TfrxComboEdit
          Left = 116
          Top = 49
          Width = 233
          Height = 21
          Style = csSimple
          TabOrder = 1
          OnChange = ComboEditChange
          OnButtonClick = ComboEditButtonClick
        end
        object LabelComboEdit: TfrxComboEdit
          Left = 116
          Top = 77
          Width = 233
          Height = 21
          Style = csSimple
          TabOrder = 2
          OnChange = ComboEditChange
          OnButtonClick = ComboEditButtonClick
        end
      end
      object ZoomPolygonComboEdit: TfrxComboEdit
        Left = 128
        Top = 391
        Width = 234
        Height = 21
        Style = csSimple
        TabOrder = 4
        OnChange = ComboEditChange
        OnButtonClick = ComboEditButtonClick
      end
      object GeodataLayerGroupBox: TGroupBox
        Tag = 6422
        Left = 12
        Top = 422
        Width = 362
        Height = 114
        Caption = 'Geodata'
        TabOrder = 6
        object DataColumnLabel: TLabel
          Tag = 6418
          Left = 12
          Top = 24
          Width = 39
          Height = 13
          Caption = 'Column:'
        end
        object BorderColorLabel: TLabel
          Tag = 6392
          Left = 12
          Top = 52
          Width = 64
          Height = 13
          Caption = 'Border Color:'
        end
        object FillColorLabel: TLabel
          Tag = 6433
          Left = 12
          Top = 80
          Width = 44
          Height = 13
          Caption = 'Fill Color:'
        end
        object DataColumnComboBox: TComboBox
          Left = 116
          Top = 21
          Width = 233
          Height = 21
          Style = csDropDownList
          TabOrder = 0
          OnChange = ComboBoxChange
        end
        object BorderColorColumnComboBox: TComboBox
          Left = 117
          Top = 49
          Width = 233
          Height = 21
          Style = csDropDownList
          TabOrder = 1
          OnChange = ComboBoxChange
        end
        object FillColorColumnComboBox: TComboBox
          Left = 117
          Top = 77
          Width = 233
          Height = 21
          Style = csDropDownList
          TabOrder = 2
          OnChange = ComboBoxChange
        end
      end
    end
    object AppearanceTabSheet: TTabSheet
      Tag = 6430
      Caption = 'Appearance'
      ImageIndex = 1
      object LayerBorderColorLabel: TLabel
        Tag = 6392
        Left = 12
        Top = 44
        Width = 62
        Height = 13
        Caption = 'Border color:'
      end
      object LayerBorderStyleLabel: TLabel
        Tag = 6432
        Left = 12
        Top = 99
        Width = 62
        Height = 13
        Caption = 'Border style:'
      end
      object LayerBorderWidthLabel: TLabel
        Tag = 6393
        Left = 12
        Top = 72
        Width = 65
        Height = 13
        Caption = 'Border width:'
      end
      object LayerFillColorLabel: TLabel
        Tag = 6433
        Left = 12
        Top = 127
        Width = 42
        Height = 13
        Caption = 'Fill color:'
      end
      object LayerPaletteLabel: TLabel
        Tag = 6434
        Left = 12
        Top = 154
        Width = 38
        Height = 13
        Caption = 'Palette:'
      end
      object LayerPointSizeLabel: TLabel
        Tag = 6435
        Left = 12
        Top = 182
        Width = 50
        Height = 13
        Caption = 'Point Size:'
      end
      object LayerHighlightColorLabel: TLabel
        Tag = 6436
        Left = 12
        Top = 210
        Width = 71
        Height = 13
        Caption = 'Highlight color:'
      end
      object LayerVisibleCheckBox: TCheckBox
        Tag = 6431
        Left = 12
        Top = 12
        Width = 257
        Height = 17
        Caption = 'Visible'
        TabOrder = 0
        OnClick = CheckBoxClick
      end
      object LayerBorderStyleComboBox: TComboBox
        Left = 128
        Top = 96
        Width = 234
        Height = 21
        Style = csDropDownList
        TabOrder = 4
        OnChange = ComboBoxChange
      end
      object LayerPaletteComboBox: TComboBox
        Left = 128
        Top = 151
        Width = 234
        Height = 21
        Style = csDropDownList
        TabOrder = 6
        OnChange = ComboBoxChange
      end
      object LayerBorderColorColorBox: TColorBox
        Left = 128
        Top = 41
        Width = 117
        Height = 22
        TabOrder = 1
        OnChange = ColorBoxChange
      end
      object LayerFillColorColorBox: TColorBox
        Left = 128
        Top = 124
        Width = 117
        Height = 22
        TabOrder = 5
        OnChange = ColorBoxChange
      end
      object LayerHighlightColorColorBox: TColorBox
        Left = 128
        Top = 207
        Width = 117
        Height = 22
        TabOrder = 9
        OnChange = ColorBoxChange
      end
      object LayerBorderWidthEdit: TEdit
        Left = 128
        Top = 69
        Width = 43
        Height = 21
        TabOrder = 2
        Text = '0'
        OnChange = SpinEditChange
        OnKeyPress = EditIntKeyPress
      end
      object LayerBorderWidthUpDown: TUpDown
        Left = 171
        Top = 69
        Width = 16
        Height = 21
        Associate = LayerBorderWidthEdit
        Max = 10000
        TabOrder = 3
      end
      object LayerPointSizeEdit: TEdit
        Left = 128
        Top = 179
        Width = 43
        Height = 21
        TabOrder = 7
        Text = '0'
        OnChange = SpinEditChange
        OnKeyPress = EditIntKeyPress
      end
      object LayerPointSizeUpDown: TUpDown
        Left = 171
        Top = 179
        Width = 16
        Height = 21
        Associate = LayerPointSizeEdit
        Max = 10000
        TabOrder = 8
      end
    end
    object ColorRangesTabSheet: TTabSheet
      Tag = 6440
      Caption = 'Color Ranges'
      ImageIndex = 2
      object StartColorLabel: TLabel
        Tag = 6441
        Left = 12
        Top = 44
        Width = 54
        Height = 13
        Caption = 'Start color:'
      end
      object MiddleColorLabel: TLabel
        Tag = 6442
        Left = 12
        Top = 72
        Width = 60
        Height = 13
        Caption = 'Middle color:'
      end
      object EndColorLabel: TLabel
        Tag = 6443
        Left = 12
        Top = 99
        Width = 48
        Height = 13
        Caption = 'End color:'
      end
      object NumColorRangesLabel: TLabel
        Tag = 6444
        Left = 12
        Top = 127
        Width = 93
        Height = 13
        Caption = 'Number of Ranges:'
      end
      object ColorRangeFactorLabel: TLabel
        Tag = 6445
        Left = 12
        Top = 154
        Width = 76
        Height = 13
        Caption = 'Ranking Factor:'
      end
      object ColorRangeVisibleCheckBox: TCheckBox
        Tag = 6391
        Left = 12
        Top = 12
        Width = 257
        Height = 17
        Caption = 'Visible'
        TabOrder = 0
        OnClick = CheckBoxClick
      end
      object ColorRangeFactorComboBox: TComboBox
        Left = 128
        Top = 151
        Width = 234
        Height = 21
        Style = csDropDownList
        TabOrder = 6
        OnChange = ComboBoxChange
      end
      object StartColorColorBox: TColorBox
        Left = 128
        Top = 41
        Width = 117
        Height = 22
        TabOrder = 1
        OnChange = ColorBoxChange
      end
      object MiddleColorColorBox: TColorBox
        Left = 128
        Top = 69
        Width = 117
        Height = 22
        TabOrder = 2
        OnChange = ColorBoxChange
      end
      object EndColorColorBox: TColorBox
        Left = 128
        Top = 96
        Width = 117
        Height = 22
        TabOrder = 3
        OnChange = ColorBoxChange
      end
      object NumColorRangesEdit: TEdit
        Left = 128
        Top = 124
        Width = 43
        Height = 21
        TabOrder = 4
        Text = '0'
        OnChange = SpinEditChange
        OnKeyPress = EditIntKeyPress
      end
      object NumColorRangesUpDown: TUpDown
        Left = 171
        Top = 124
        Width = 16
        Height = 21
        Associate = NumColorRangesEdit
        Max = 10000
        TabOrder = 5
      end
      object CREditBtn: TButton
        Left = 12
        Top = 184
        Width = 75
        Height = 25
        Caption = 'Edit...'
        TabOrder = 7
        OnClick = CREditBtnClick
      end
    end
    object SizeRangesTabSheet: TTabSheet
      Tag = 6450
      Caption = 'Size Ranges'
      ImageIndex = 3
      object StartSizeLabel: TLabel
        Tag = 6451
        Left = 12
        Top = 44
        Width = 50
        Height = 13
        Caption = 'Start Size:'
      end
      object EndSizeLabel: TLabel
        Tag = 6452
        Left = 12
        Top = 72
        Width = 44
        Height = 13
        Caption = 'End Size:'
      end
      object NumSizeRangesLabel: TLabel
        Tag = 6444
        Left = 12
        Top = 99
        Width = 93
        Height = 13
        Caption = 'Number of Ranges:'
      end
      object SizeRangeFactorLabel: TLabel
        Tag = 6445
        Left = 12
        Top = 127
        Width = 76
        Height = 13
        Caption = 'Ranking Factor:'
      end
      object SizeRangeVisibleCheckBox: TCheckBox
        Tag = 6431
        Left = 12
        Top = 12
        Width = 257
        Height = 18
        Caption = 'Visible'
        TabOrder = 0
        OnClick = CheckBoxClick
      end
      object SizeRangeFactorComboBox: TComboBox
        Left = 128
        Top = 124
        Width = 234
        Height = 21
        Style = csDropDownList
        TabOrder = 7
        OnChange = ComboBoxChange
      end
      object NumSizeRangesEdit: TEdit
        Left = 128
        Top = 97
        Width = 43
        Height = 21
        TabOrder = 5
        Text = '0'
        OnChange = SpinEditChange
        OnKeyPress = EditIntKeyPress
      end
      object NumSizeRangesUpDown: TUpDown
        Left = 171
        Top = 97
        Width = 16
        Height = 21
        Associate = NumSizeRangesEdit
        Max = 10000
        TabOrder = 6
      end
      object StartSizeEdit: TEdit
        Left = 128
        Top = 41
        Width = 43
        Height = 21
        TabOrder = 1
        Text = '0'
        OnChange = SpinEditChange
        OnKeyPress = EditIntKeyPress
      end
      object StartSizeUpDown: TUpDown
        Left = 171
        Top = 41
        Width = 16
        Height = 21
        Associate = StartSizeEdit
        Max = 10000
        TabOrder = 2
      end
      object EndSizeEdit: TEdit
        Left = 128
        Top = 69
        Width = 43
        Height = 21
        TabOrder = 3
        Text = '0'
        OnChange = SpinEditChange
        OnKeyPress = EditIntKeyPress
      end
      object EndSizeUpDown: TUpDown
        Left = 171
        Top = 69
        Width = 16
        Height = 21
        Associate = EndSizeEdit
        Max = 10000
        TabOrder = 4
      end
      object SREditBtn: TButton
        Left = 12
        Top = 160
        Width = 75
        Height = 25
        Caption = 'Edit...'
        TabOrder = 8
        OnClick = SREditBtnClick
      end
    end
    object LabelsTabSheet: TTabSheet
      Tag = 6460
      Caption = 'Labels'
      ImageIndex = 4
      DesignSize = (
        384
        631)
      object LabelColumnLabel: TLabel
        Tag = 6462
        Left = 12
        Top = 44
        Width = 67
        Height = 13
        Caption = 'Label Column:'
      end
      object LabelFormatLabel: TLabel
        Tag = 6399
        Left = 12
        Top = 72
        Width = 38
        Height = 13
        Caption = 'Format:'
      end
      object LabelKindLabel: TLabel
        Tag = 6461
        Left = 12
        Top = 17
        Width = 52
        Height = 13
        Caption = 'Label Kind:'
      end
      object LabelFontLabel: TLabel
        Left = 128
        Top = 99
        Width = 34
        Height = 13
        Anchors = [akTop, akRight]
        Caption = 'Sample'
      end
      object LabelColumnComboBox: TComboBox
        Left = 128
        Top = 41
        Width = 234
        Height = 21
        Style = csDropDownList
        TabOrder = 1
        OnChange = ComboBoxChange
      end
      object LabelFormatEdit: TEdit
        Left = 128
        Top = 69
        Width = 234
        Height = 21
        TabOrder = 2
        OnChange = EditChange
      end
      object LabelKindComboBox: TComboBox
        Left = 128
        Top = 14
        Width = 234
        Height = 21
        Style = csDropDownList
        TabOrder = 0
        OnChange = ComboBoxChange
      end
      object LabelFontButton: TButton
        Tag = 6397
        Left = 13
        Top = 95
        Width = 80
        Height = 20
        Anchors = [akTop, akRight]
        Caption = 'Font...'
        TabOrder = 3
        OnClick = FontButtonClick
      end
    end
  end
  object MapOptionsPageControl: TPageControl
    Left = 346
    Top = 7
    Width = 392
    Height = 461
    ActivePage = ColorScaleTabSheet
    TabOrder = 1
    object GeneralTabSheet: TTabSheet
      Tag = 6380
      Caption = 'General'
      DesignSize = (
        384
        433)
      object MercatorCheckBox: TCheckBox
        Tag = 6382
        Left = 12
        Top = 40
        Width = 273
        Height = 17
        Caption = 'Mercator projection'
        TabOrder = 1
        OnClick = CheckBoxClick
      end
      object KeepAspectCheckBox: TCheckBox
        Tag = 6381
        Left = 12
        Top = 12
        Width = 273
        Height = 17
        Caption = 'Keep Aspect Ratio'
        TabOrder = 0
        OnClick = CheckBoxClick
      end
      object FillButton: TButton
        Tag = 6383
        Left = 12
        Top = 67
        Width = 80
        Height = 20
        Anchors = [akTop, akRight]
        Caption = 'Fill...'
        TabOrder = 2
        OnClick = FillButtonClick
      end
      object FrameButton: TButton
        Tag = 5103
        Left = 12
        Top = 94
        Width = 80
        Height = 21
        Anchors = [akTop, akRight]
        Caption = 'Frame...'
        TabOrder = 3
        OnClick = FrameButtonClick
      end
    end
    object ColorScaleTabSheet: TTabSheet
      Tag = 6390
      Caption = 'Color scale'
      ImageIndex = 1
      DesignSize = (
        384
        433)
      object ColorBorderWidthLabel: TLabel
        Tag = 6393
        Left = 12
        Top = 72
        Width = 67
        Height = 13
        Caption = 'Border Width:'
      end
      object ColorBorderColorLabel: TLabel
        Tag = 6392
        Left = 12
        Top = 44
        Width = 64
        Height = 13
        Caption = 'Border Color:'
      end
      object ColorTopLeftSpeedButton: TSpeedButton
        Left = 128
        Top = 99
        Width = 20
        Height = 20
        Anchors = [akTop, akRight]
        GroupIndex = 1
        OnClick = DockSpeedButtonClick
      end
      object ColorMiddleCenterSpeedButton: TSpeedButton
        Left = 149
        Top = 119
        Width = 19
        Height = 19
        Anchors = [akTop, akRight]
        GroupIndex = 1
        OnClick = DockSpeedButtonClick
      end
      object ColorBottomRightSpeedButton: TSpeedButton
        Left = 169
        Top = 139
        Width = 19
        Height = 19
        Anchors = [akTop, akRight]
        GroupIndex = 1
        OnClick = DockSpeedButtonClick
      end
      object ColorBottomCenterSpeedButton: TSpeedButton
        Left = 149
        Top = 139
        Width = 18
        Height = 19
        Anchors = [akTop, akRight]
        GroupIndex = 1
        OnClick = DockSpeedButtonClick
      end
      object ColorBottomLeftSpeedButton: TSpeedButton
        Left = 128
        Top = 139
        Width = 20
        Height = 19
        Anchors = [akTop, akRight]
        GroupIndex = 1
        OnClick = DockSpeedButtonClick
      end
      object ColorMiddleRightSpeedButton: TSpeedButton
        Left = 169
        Top = 119
        Width = 19
        Height = 19
        Anchors = [akTop, akRight]
        GroupIndex = 1
        OnClick = DockSpeedButtonClick
      end
      object ColorMiddleLeftSpeedButton: TSpeedButton
        Left = 128
        Top = 119
        Width = 20
        Height = 19
        Anchors = [akTop, akRight]
        GroupIndex = 1
        OnClick = DockSpeedButtonClick
      end
      object ColorTopRightSpeedButton: TSpeedButton
        Left = 169
        Top = 99
        Width = 19
        Height = 20
        Anchors = [akTop, akRight]
        GroupIndex = 1
        OnClick = DockSpeedButtonClick
      end
      object ColorTopCenterSpeedButton: TSpeedButton
        Left = 149
        Top = 99
        Width = 18
        Height = 20
        Anchors = [akTop, akRight]
        GroupIndex = 1
        OnClick = DockSpeedButtonClick
      end
      object ColorScaleDockLabel: TLabel
        Tag = 6394
        Left = 12
        Top = 99
        Width = 27
        Height = 13
        Anchors = [akTop, akRight]
        Caption = 'Dock:'
      end
      object ColorScaleTitleGroupBox: TGroupBox
        Tag = 6395
        Left = 12
        Top = 180
        Width = 360
        Height = 83
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Title'
        TabOrder = 4
        DesignSize = (
          360
          83)
        object ColorScaleTitleTextLabel: TLabel
          Tag = 6396
          Left = 12
          Top = 24
          Width = 26
          Height = 13
          Caption = 'Text:'
        end
        object ColorScaleTitleFontSampleLabel: TLabel
          Left = 116
          Top = 52
          Width = 34
          Height = 13
          Anchors = [akTop, akRight]
          Caption = 'Sample'
        end
        object ColorScaleTitleTextEdit: TEdit
          Left = 116
          Top = 21
          Width = 233
          Height = 21
          Anchors = [akTop, akRight]
          TabOrder = 0
          OnChange = EditChange
        end
        object ColorScaleTitleFontButton: TButton
          Tag = 6397
          Left = 12
          Top = 47
          Width = 80
          Height = 21
          Anchors = [akTop, akRight]
          Caption = 'Font...'
          TabOrder = 1
          OnClick = FontButtonClick
        end
      end
      object ColorScaleValuesGroupBox: TGroupBox
        Tag = 6398
        Left = 12
        Top = 290
        Width = 360
        Height = 82
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Values'
        TabOrder = 5
        DesignSize = (
          360
          82)
        object ColorScaleValuesFormatLabel: TLabel
          Left = 12
          Top = 24
          Width = 38
          Height = 13
          Caption = 'Format:'
        end
        object ColorScaleValuesFontSampleLabel: TLabel
          Left = 116
          Top = 52
          Width = 34
          Height = 13
          Anchors = [akTop, akRight]
          Caption = 'Sample'
        end
        object ColorScaleValuesFormatEdit: TEdit
          Left = 116
          Top = 21
          Width = 233
          Height = 21
          Anchors = [akTop, akRight]
          TabOrder = 0
          OnChange = EditChange
        end
        object ColorScaleValuesFontButton: TButton
          Tag = 6397
          Left = 12
          Top = 47
          Width = 80
          Height = 22
          Anchors = [akTop, akRight]
          Caption = 'Font...'
          TabOrder = 1
          OnClick = FontButtonClick
        end
      end
      object ColorScaleVisibleCheckBox: TCheckBox
        Tag = 6391
        Left = 12
        Top = 12
        Width = 185
        Height = 17
        Caption = 'Visible'
        TabOrder = 0
        OnClick = CheckBoxClick
      end
      object ColorBorderColorBox: TColorBox
        Left = 128
        Top = 41
        Width = 117
        Height = 22
        TabOrder = 1
        OnChange = ColorBoxChange
      end
      object ColorBorderWidthEdit: TEdit
        Left = 128
        Top = 69
        Width = 43
        Height = 21
        TabOrder = 2
        Text = '0'
        OnChange = SpinEditChange
        OnKeyPress = EditIntKeyPress
      end
      object ColorBorderWidthUpDown: TUpDown
        Left = 171
        Top = 69
        Width = 16
        Height = 21
        Associate = ColorBorderWidthEdit
        Max = 10000
        TabOrder = 3
      end
    end
    object SizeScaleTabSheet: TTabSheet
      Tag = 6400
      Caption = 'Size Scale'
      ImageIndex = 2
      DesignSize = (
        384
        433)
      object SizeScaleDockLabel: TLabel
        Tag = 6394
        Left = 12
        Top = 99
        Width = 27
        Height = 13
        Anchors = [akTop, akRight]
        Caption = 'Dock:'
      end
      object SizeTopCenterSpeedButton: TSpeedButton
        Left = 149
        Top = 99
        Width = 18
        Height = 20
        Anchors = [akTop, akRight]
        GroupIndex = 1
        OnClick = DockSpeedButtonClick
      end
      object SizeTopRightSpeedButton: TSpeedButton
        Left = 169
        Top = 99
        Width = 19
        Height = 20
        Anchors = [akTop, akRight]
        GroupIndex = 1
        OnClick = DockSpeedButtonClick
      end
      object SizeMiddleLeftSpeedButton: TSpeedButton
        Left = 128
        Top = 119
        Width = 20
        Height = 19
        Anchors = [akTop, akRight]
        GroupIndex = 1
        OnClick = DockSpeedButtonClick
      end
      object SizeMiddleRightSpeedButton: TSpeedButton
        Left = 169
        Top = 119
        Width = 19
        Height = 19
        Anchors = [akTop, akRight]
        GroupIndex = 1
        OnClick = DockSpeedButtonClick
      end
      object SizeBottomLeftSpeedButton: TSpeedButton
        Left = 128
        Top = 139
        Width = 20
        Height = 19
        Anchors = [akTop, akRight]
        GroupIndex = 1
        OnClick = DockSpeedButtonClick
      end
      object SizeBottomCenterSpeedButton: TSpeedButton
        Left = 149
        Top = 139
        Width = 18
        Height = 19
        Anchors = [akTop, akRight]
        GroupIndex = 1
        OnClick = DockSpeedButtonClick
      end
      object SizeBottomRightSpeedButton: TSpeedButton
        Left = 169
        Top = 139
        Width = 19
        Height = 19
        Anchors = [akTop, akRight]
        GroupIndex = 1
        OnClick = DockSpeedButtonClick
      end
      object SizeMiddleCenterSpeedButton: TSpeedButton
        Left = 149
        Top = 119
        Width = 19
        Height = 19
        Anchors = [akTop, akRight]
        GroupIndex = 1
        OnClick = DockSpeedButtonClick
      end
      object SizeTopLeftSpeedButton: TSpeedButton
        Left = 128
        Top = 99
        Width = 20
        Height = 20
        Anchors = [akTop, akRight]
        GroupIndex = 1
        OnClick = DockSpeedButtonClick
      end
      object SizeBorderColorLabel: TLabel
        Tag = 6392
        Left = 12
        Top = 44
        Width = 64
        Height = 13
        Caption = 'Border Color:'
      end
      object SizeBorderWidthLabel: TLabel
        Tag = 6393
        Left = 12
        Top = 72
        Width = 67
        Height = 13
        Caption = 'Border Width:'
      end
      object SizeScaleVisibleCheckBox: TCheckBox
        Tag = 6391
        Left = 12
        Top = 12
        Width = 185
        Height = 17
        Caption = 'Visible'
        TabOrder = 0
        OnClick = CheckBoxClick
      end
      object SizeBorderColorBox: TColorBox
        Left = 128
        Top = 41
        Width = 117
        Height = 22
        TabOrder = 1
        OnChange = ColorBoxChange
      end
      object SizeScaleValuesGroupBox: TGroupBox
        Tag = 6398
        Left = 12
        Top = 290
        Width = 360
        Height = 82
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Values'
        TabOrder = 5
        DesignSize = (
          360
          82)
        object SizeScaleValuesFormatLabel: TLabel
          Left = 12
          Top = 24
          Width = 38
          Height = 13
          Caption = 'Format:'
        end
        object SizeScaleValuesFontSampleLabel: TLabel
          Left = 116
          Top = 52
          Width = 34
          Height = 13
          Anchors = [akTop, akRight]
          Caption = 'Sample'
        end
        object SizeScaleValuesFormatEdit: TEdit
          Left = 116
          Top = 21
          Width = 233
          Height = 21
          Anchors = [akTop, akRight]
          TabOrder = 0
          OnChange = EditChange
        end
        object SizeScaleValuesFontButton: TButton
          Tag = 6397
          Left = 12
          Top = 47
          Width = 80
          Height = 22
          Anchors = [akTop, akRight]
          Caption = 'Font...'
          TabOrder = 1
          OnClick = FontButtonClick
        end
      end
      object SizeScaleTitleGroupBox: TGroupBox
        Tag = 6395
        Left = 12
        Top = 180
        Width = 360
        Height = 83
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Title'
        TabOrder = 4
        DesignSize = (
          360
          83)
        object SizeScaleTitleTextLabel: TLabel
          Tag = 6396
          Left = 12
          Top = 24
          Width = 26
          Height = 13
          Caption = 'Text:'
        end
        object SizeScaleTitleFontSampleLabel: TLabel
          Left = 116
          Top = 52
          Width = 34
          Height = 13
          Anchors = [akTop, akRight]
          Caption = 'Sample'
        end
        object SizeScaleTitleTextEdit: TEdit
          Left = 116
          Top = 21
          Width = 233
          Height = 21
          Anchors = [akTop, akRight]
          TabOrder = 0
          OnChange = EditChange
        end
        object SizeScaleTitleFontButton: TButton
          Tag = 6397
          Left = 12
          Top = 47
          Width = 80
          Height = 21
          Anchors = [akTop, akRight]
          Caption = 'Font...'
          TabOrder = 1
          OnClick = FontButtonClick
        end
      end
      object SizeBorderWidthEdit: TEdit
        Left = 128
        Top = 69
        Width = 43
        Height = 21
        TabOrder = 2
        Text = '0'
        OnChange = SpinEditChange
        OnKeyPress = EditIntKeyPress
      end
      object SizeBorderWidthUpDown: TUpDown
        Left = 171
        Top = 69
        Width = 16
        Height = 21
        Associate = SizeBorderWidthEdit
        Max = 10000
        TabOrder = 3
      end
    end
  end
  object MapGroupBox: TGroupBox
    Tag = 6371
    Left = 6
    Top = 6
    Width = 325
    Height = 581
    Caption = 'Map'
    TabOrder = 0
    object UpButton: TSpeedButton
      Left = 260
      Top = 148
      Width = 23
      Height = 22
      OnClick = UpButtonClick
    end
    object DownButton: TSpeedButton
      Left = 288
      Top = 148
      Width = 23
      Height = 22
      OnClick = DownButtonClick
    end
    object MapSamplePaintBox: TPaintBox
      Left = 12
      Top = 188
      Width = 301
      Height = 273
      OnPaint = MapSamplePaintBoxPaint
    end
    object MapTreeView: TTreeView
      Left = 12
      Top = 20
      Width = 301
      Height = 121
      HideSelection = False
      Indent = 19
      ShowButtons = False
      ShowLines = False
      TabOrder = 0
      OnChange = MapTreeViewChange
    end
    object AddButton: TButton
      Tag = 6372
      Left = 12
      Top = 148
      Width = 87
      Height = 25
      Caption = 'Add...'
      TabOrder = 1
      OnClick = AddButtonClick
    end
    object DeleteButton: TButton
      Tag = 6356
      Left = 106
      Top = 148
      Width = 87
      Height = 25
      Caption = 'Delete'
      TabOrder = 2
      OnClick = DeleteButtonClick
    end
  end
  object OkButton: TButton
    Tag = 1
    Left = 582
    Top = 674
    Width = 74
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 3
  end
  object CancelButton: TButton
    Tag = 2
    Left = 662
    Top = 674
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 4
  end
  object FontDialog: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Left = 764
    Top = 596
  end
end
