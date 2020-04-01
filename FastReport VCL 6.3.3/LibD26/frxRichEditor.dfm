object frxRichEditorForm: TfrxRichEditorForm
  Left = 269
  Top = 122
  AutoScroll = False
  BorderIcons = [biSystemMenu, biMinimize, biMaximize, biHelp]
  Caption = 'Rich Editor'
  ClientHeight = 300
  ClientWidth = 625
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = True
  Position = poScreenCenter
  ShowHint = True
  OnCreate = FormCreate
  OnHide = FormHide
  OnKeyDown = FormKeyDown
  OnPaint = FormPaint
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object SpeedBar: TToolBar
    Left = 0
    Top = 0
    Width = 625
    Height = 33
    BorderWidth = 2
    ButtonHeight = 23
    Flat = True
    Indent = 1
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    Wrapable = False
    object OpenB: TToolButton
      Left = 1
      Top = 0
      Hint = 'Open File'
      ImageIndex = 1
      OnClick = FileOpen
    end
    object SaveB: TToolButton
      Left = 24
      Top = 0
      Hint = 'Save File'
      ImageIndex = 2
      OnClick = FileSaveAs
    end
    object Sep1: TToolButton
      Left = 47
      Top = 0
      Width = 8
      ImageIndex = 2
      Style = tbsSeparator
    end
    object UndoB: TToolButton
      Left = 55
      Top = 0
      Hint = 'Undo'
      ImageIndex = 8
      OnClick = EditUndo
    end
    object TTB: TToolButton
      Left = 78
      Top = 0
      Hint = 'Font'
      ImageIndex = 59
      OnClick = SelectFont
    end
    object ExprB: TToolButton
      Left = 101
      Top = 0
      Hint = 'Insert Expression'
      ImageIndex = 70
      OnClick = ExprBClick
    end
    object Sep2: TToolButton
      Left = 124
      Top = 0
      Width = 8
      ImageIndex = 2
      Style = tbsSeparator
    end
    object CancelB: TToolButton
      Left = 132
      Top = 0
      Hint = 'Cancel'
      ImageIndex = 55
      OnClick = CancelBClick
    end
    object OkB: TToolButton
      Left = 155
      Top = 0
      Hint = 'OK'
      ImageIndex = 56
      OnClick = OkBClick
    end
    object Sep3: TfrxTBPanel
      Left = 178
      Top = 0
      Width = 186
      Height = 23
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 0
      object FontNameCB: TfrxFontComboBox
        Left = 6
        Top = 1
        Width = 122
        Height = 20
        Hint = 'Font Name'
        MRURegKey = '\Software\FastReport\MRUFont'
        DropDownCount = 12
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ItemHeight = 14
        ParentFont = False
        TabOrder = 0
        OnChange = FontNameCBChange
      end
      object FontSizeCB: TfrxComboBox
        Left = 134
        Top = 1
        Width = 45
        Height = 20
        Hint = 'Font Size'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ItemHeight = 14
        Items.Strings = (
          '5'
          '6'
          '7'
          '8'
          '9'
          '10'
          '11'
          '12'
          '14'
          '16'
          '18'
          '20'
          '22'
          '24'
          '26'
          '28'
          '36'
          '48'
          '72')
        ListWidth = 0
        ParentFont = False
        TabOrder = 1
        ItemIndex = -1
        OnChange = FontSizeCBChange
      end
    end
    object BoldB: TToolButton
      Left = 364
      Top = 0
      Hint = 'Bold'
      AllowAllUp = True
      ImageIndex = 20
      Style = tbsCheck
      OnClick = BoldBClick
    end
    object ItalicB: TToolButton
      Left = 387
      Top = 0
      Hint = 'Italic'
      AllowAllUp = True
      ImageIndex = 21
      Style = tbsCheck
      OnClick = BoldBClick
    end
    object UnderlineB: TToolButton
      Left = 410
      Top = 0
      Hint = 'Underline'
      AllowAllUp = True
      ImageIndex = 22
      Style = tbsCheck
      OnClick = BoldBClick
    end
    object Sep4: TToolButton
      Left = 433
      Top = 0
      Width = 8
      ImageIndex = 2
      Style = tbsSeparator
    end
    object LeftAlignB: TToolButton
      Left = 441
      Top = 0
      Hint = 'Left Align'
      Grouped = True
      ImageIndex = 25
      Style = tbsCheck
      OnClick = AlignButtonClick
    end
    object CenterAlignB: TToolButton
      Tag = 1
      Left = 464
      Top = 0
      Hint = 'Center Align'
      Grouped = True
      ImageIndex = 26
      Style = tbsCheck
      OnClick = AlignButtonClick
    end
    object RightAlignB: TToolButton
      Tag = 2
      Left = 487
      Top = 0
      Hint = 'Right Align'
      Grouped = True
      ImageIndex = 27
      Style = tbsCheck
      OnClick = AlignButtonClick
    end
    object BlockAlignB: TToolButton
      Tag = 3
      Left = 510
      Top = 0
      Grouped = True
      ImageIndex = 28
      Style = tbsCheck
      OnClick = AlignButtonClick
    end
    object Sep5: TToolButton
      Left = 533
      Top = 0
      Width = 8
      ImageIndex = 2
      Style = tbsSeparator
    end
    object BulletsB: TToolButton
      Left = 541
      Top = 0
      Hint = 'Bullets'
      AllowAllUp = True
      ImageIndex = 71
      Style = tbsCheck
      OnClick = BulletsBClick
    end
  end
  object Ruler: TPanel
    Left = 0
    Top = 33
    Width = 625
    Height = 26
    Align = alTop
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BevelOuter = bvNone
    BorderWidth = 1
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnResize = RulerResize
    object RulerLine: TBevel
      Left = 4
      Top = 12
      Width = 565
      Height = 9
      Shape = bsTopLine
    end
    object FirstInd: TLabel
      Tag = 316
      Left = 2
      Top = 2
      Width = 10
      Height = 9
      AutoSize = False
      Caption = #1082
      DragCursor = crArrow
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Wingdings'
      Font.Style = []
      ParentFont = False
      OnMouseDown = RulerItemMouseDown
      OnMouseMove = RulerItemMouseMove
      OnMouseUp = FirstIndMouseUp
    end
    object LeftInd: TLabel
      Tag = 317
      Left = 2
      Top = 12
      Width = 10
      Height = 11
      AutoSize = False
      Caption = #1081
      DragCursor = crArrow
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Wingdings'
      Font.Style = []
      ParentFont = False
      OnMouseDown = RulerItemMouseDown
      OnMouseMove = RulerItemMouseMove
      OnMouseUp = LeftIndMouseUp
    end
    object RightInd: TLabel
      Tag = 318
      Left = 535
      Top = 12
      Width = 10
      Height = 12
      Caption = #1081
      DragCursor = crArrow
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Wingdings'
      Font.Style = []
      ParentFont = False
      OnMouseDown = RulerItemMouseDown
      OnMouseMove = RulerItemMouseMove
      OnMouseUp = RightIndMouseUp
    end
  end
  object OpenDialog: TOpenDialog
    Left = 407
    Top = 237
  end
  object SaveDialog: TSaveDialog
    Left = 437
    Top = 237
  end
  object FontDialog1: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Left = 377
    Top = 238
  end
end
