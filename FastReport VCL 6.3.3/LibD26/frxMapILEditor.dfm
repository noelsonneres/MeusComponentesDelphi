object frxMapILEditorForm: TfrxMapILEditorForm
  Tag = 6586
  Left = 521
  Top = 162
  Caption = 'frxMapILEditorForm'
  ClientHeight = 509
  ClientWidth = 680
  Color = clBtnFace
  Constraints.MinHeight = 543
  Constraints.MinWidth = 688
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -10
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnMouseWheel = FormMouseWheel
  OnResize = FormResize
  DesignSize = (
    680
    509)
  PixelsPerInch = 96
  TextHeight = 12
  object btnCancel: TButton
    Tag = 2
    Left = 599
    Top = 480
    Width = 73
    Height = 24
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object btnOk: TButton
    Tag = 1
    Left = 512
    Top = 480
    Width = 73
    Height = 24
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object ShapeGroupBox: TGroupBox
    Left = 509
    Top = 35
    Width = 168
    Height = 248
    Anchors = [akTop, akRight]
    Caption = 'Shape'
    TabOrder = 2
    Visible = False
    DesignSize = (
      168
      248)
    object TagsLabel: TLabel
      Tag = 6575
      Left = 3
      Top = 75
      Width = 21
      Height = 12
      Caption = 'Tags'
    end
    object TagsMemo: TMemo
      Left = 2
      Top = 92
      Width = 161
      Height = 151
      Anchors = [akLeft, akTop, akBottom]
      ScrollBars = ssBoth
      TabOrder = 2
    end
    object CancelShapeButton: TButton
      Tag = 2
      Left = 90
      Top = 45
      Width = 74
      Height = 25
      Cancel = True
      Caption = 'Cancel'
      TabOrder = 1
      OnClick = CancelShapeButtonClick
    end
    object SaveShapeButton: TButton
      Tag = 6570
      Left = 3
      Top = 45
      Width = 74
      Height = 25
      Caption = 'Save'
      Default = True
      TabOrder = 0
      OnClick = SaveShapeButtonClick
    end
    object RemoveShapeButton: TButton
      Tag = 6577
      Left = 3
      Top = 15
      Width = 161
      Height = 25
      Caption = 'Remove Shape from Layer'
      Default = True
      TabOrder = 3
      OnClick = RemoveShapeButtonClick
    end
  end
  object MapPanel: TPanel
    Left = 0
    Top = 31
    Width = 506
    Height = 478
    Align = alLeft
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 3
    object MapPaintBox: TPaintBox
      Left = 2
      Top = 2
      Width = 502
      Height = 474
      Align = alClient
      OnMouseDown = MapPaintBoxMouseDown
      OnMouseMove = MapPaintBoxMouseMove
      OnMouseUp = MapPaintBoxMouseUp
      OnPaint = MapPaintBoxPaint
    end
  end
  object PolyGroupBox: TGroupBox
    Left = 509
    Top = 282
    Width = 168
    Height = 45
    Anchors = [akTop, akRight]
    Caption = 'Poly'
    TabOrder = 4
    Visible = False
    object DeletePointButton: TButton
      Tag = 6576
      Left = 3
      Top = 15
      Width = 161
      Height = 25
      Caption = 'Delete Edited Point'
      Default = True
      TabOrder = 0
      OnClick = DeletePointButtonClick
    end
  end
  object PictureGroupBox: TGroupBox
    Left = 303
    Top = 103
    Width = 168
    Height = 67
    Anchors = [akTop, akRight]
    Caption = 'Picture'
    TabOrder = 5
    Visible = False
    DesignSize = (
      168
      67)
    object EditPictureButton: TButton
      Tag = 6583
      Left = 3
      Top = 15
      Width = 161
      Height = 25
      Anchors = [akLeft, akBottom]
      Caption = 'Edit Picture'
      Default = True
      TabOrder = 0
      OnClick = EditPictureButtonClick
    end
    object ConstrainProportionsCheckBox: TCheckBox
      Tag = 6584
      Left = 3
      Top = 47
      Width = 161
      Height = 13
      Anchors = [akLeft, akBottom]
      Caption = 'Constrain Proportions'
      TabOrder = 1
      OnClick = ConstrainProportionsCheckBoxClick
    end
  end
  object LegendGroupBox: TGroupBox
    Left = 303
    Top = 282
    Width = 168
    Height = 187
    Anchors = [akTop, akRight]
    Caption = 'Legend'
    TabOrder = 6
    Visible = False
    DesignSize = (
      168
      187)
    object LabelFontLabel: TLabel
      Left = 3
      Top = 36
      Width = 32
      Height = 12
      Anchors = [akTop, akRight]
      Caption = 'Sample'
    end
    object TextMemo: TMemo
      Left = 3
      Top = 69
      Width = 161
      Height = 114
      Anchors = [akLeft, akTop, akBottom]
      ScrollBars = ssBoth
      TabOrder = 1
      OnChange = TextMemoChange
    end
    object LabelFontButton: TButton
      Tag = 6397
      Left = 3
      Top = 15
      Width = 75
      Height = 19
      Anchors = [akTop, akRight]
      Caption = 'Font...'
      TabOrder = 0
      OnClick = LabelFontButtonClick
    end
  end
  object TopPanel: TPanel
    Left = 0
    Top = 0
    Width = 680
    Height = 31
    Align = alTop
    BevelInner = bvLowered
    TabOrder = 7
    object SelectSpeedButton: TSpeedButton
      Tag = 6571
      Left = 6
      Top = 6
      Width = 72
      Height = 19
      GroupIndex = 1
      Down = True
      Caption = 'Select'
    end
    object PointSpeedButton: TSpeedButton
      Tag = 6572
      Left = 84
      Top = 6
      Width = 72
      Height = 19
      GroupIndex = 1
      Caption = 'Point'
    end
    object PointMenuSpeedButton: TSpeedButton
      Left = 155
      Top = 6
      Width = 15
      Height = 19
      OnClick = PointMenuSpeedButtonClick
    end
    object RectSpeedButton: TSpeedButton
      Tag = 6578
      Left = 177
      Top = 6
      Width = 72
      Height = 19
      GroupIndex = 1
      Caption = 'Rectangle'
    end
    object RectMenuSpeedButton: TSpeedButton
      Left = 249
      Top = 6
      Width = 15
      Height = 19
      OnClick = RectMenuSpeedButtonClick
    end
    object PictureSpeedButton: TSpeedButton
      Tag = 6582
      Left = 270
      Top = 6
      Width = 72
      Height = 19
      GroupIndex = 1
      Caption = 'Picture'
    end
    object PictureMenuSpeedButton: TSpeedButton
      Left = 341
      Top = 6
      Width = 15
      Height = 19
      OnClick = PictureMenuSpeedButtonClick
    end
    object TemplateSpeedButton: TSpeedButton
      Left = 363
      Top = 6
      Width = 72
      Height = 19
      GroupIndex = 1
      Caption = 'Template'
      Visible = False
    end
    object TemplateMenuSpeedButton: TSpeedButton
      Left = 434
      Top = 6
      Width = 15
      Height = 19
      Visible = False
      OnClick = TemplateMenuSpeedButtonClick
    end
  end
  object FontDialog: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Left = 24
    Top = 60
  end
  object PointPopupMenu: TPopupMenu
    AutoHotkeys = maManual
    Left = 56
    Top = 113
    object Point1: TMenuItem
      Tag = 6572
      Caption = 'Point'
      OnClick = Point1Click
    end
    object Polyline1: TMenuItem
      Tag = 6573
      Caption = 'Polyline'
      OnClick = Point1Click
    end
    object Polygon1: TMenuItem
      Tag = 6574
      Caption = 'Polygon'
      OnClick = Point1Click
    end
  end
  object RectPopupMenu: TPopupMenu
    AutoHotkeys = maManual
    Left = 56
    Top = 169
    object Rectangle1: TMenuItem
      Tag = 6578
      Caption = 'Rectangle'
      OnClick = Rectangle1Click
    end
    object Ellipse1: TMenuItem
      Tag = 6580
      Caption = 'Ellipse'
      OnClick = Rectangle1Click
    end
    object Diamond1: TMenuItem
      Tag = 6581
      Caption = 'Diamond'
      OnClick = Rectangle1Click
    end
  end
  object PicturePopupMenu: TPopupMenu
    AutoHotkeys = maManual
    Left = 56
    Top = 225
    object Picture1: TMenuItem
      Tag = 6582
      Caption = 'Picture'
      OnClick = Picture1Click
    end
    object Legend1: TMenuItem
      Tag = 6585
      Caption = 'Legend'
      OnClick = Picture1Click
    end
  end
  object TemplatePopupMenu: TPopupMenu
    AutoHotkeys = maManual
    Left = 56
    Top = 281
  end
end
