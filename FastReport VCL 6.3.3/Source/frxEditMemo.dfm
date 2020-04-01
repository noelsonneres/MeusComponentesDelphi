object frxMemoEditorForm: TfrxMemoEditorForm
  Left = 200
  Top = 107
  Width = 527
  Height = 400
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'Memo'
  Color = clBtnFace
  Constraints.MinHeight = 352
  Constraints.MinWidth = 520
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = True
  ShowHint = True
  OnCreate = FormCreate
  OnHide = FormHide
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  DesignSize = (
    511
    362)
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 519
    Height = 328
    ActivePage = TextTS
    Anchors = [akLeft, akTop, akRight, akBottom]
    Constraints.MinHeight = 252
    Constraints.MinWidth = 324
    TabOrder = 0
    OnChange = PageControl1Change
    object TextTS: TTabSheet
      Caption = 'Text'
      object ToolBar: TToolBar
        Left = 0
        Top = 0
        Width = 511
        Height = 27
        ButtonHeight = 23
        EdgeBorders = []
        TabOrder = 0
        object ExprB: TToolButton
          Left = 0
          Top = 2
          Hint = 'Insert Expression'
          ImageIndex = 70
          OnClick = ExprBClick
        end
        object AggregateB: TToolButton
          Left = 23
          Top = 2
          ImageIndex = 85
          OnClick = AggregateBClick
        end
        object WordWrapB: TToolButton
          Left = 46
          Top = 2
          Hint = 'Word Wrap'
          AllowAllUp = True
          ImageIndex = 25
          Style = tbsCheck
          OnClick = WordWrapBClick
        end
      end
    end
    object FormatTS: TTabSheet
      Caption = 'Format'
      ImageIndex = 1
    end
    object HighlightTS: TTabSheet
      Caption = 'Highlight'
      ImageIndex = 2
    end
  end
  object OkB: TButton
    Left = 360
    Top = 336
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object CancelB: TButton
    Left = 440
    Top = 336
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
end
