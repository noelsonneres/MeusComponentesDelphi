object frxHighlightEditorForm: TfrxHighlightEditorForm
  Left = 195
  Top = 120
  BorderStyle = bsDialog
  Caption = 'Highlight'
  ClientHeight = 288
  ClientWidth = 492
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
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
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object OKB: TButton
    Left = 330
    Top = 256
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object CancelB: TButton
    Left = 410
    Top = 256
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object ConditionsGB: TGroupBox
    Left = 8
    Top = 8
    Width = 297
    Height = 235
    Caption = 'Conditions'
    TabOrder = 2
    object UpB: TSpeedButton
      Left = 210
      Top = 176
      Width = 23
      Height = 22
      OnClick = UpBClick
    end
    object DownB: TSpeedButton
      Left = 210
      Top = 200
      Width = 23
      Height = 22
      OnClick = DownBClick
    end
    object HighlightsLB: TListBox
      Left = 12
      Top = 18
      Width = 189
      Height = 204
      ItemHeight = 13
      TabOrder = 0
      OnClick = HighlightsLBClick
    end
    object AddB: TButton
      Left = 210
      Top = 18
      Width = 75
      Height = 25
      Caption = 'Add'
      TabOrder = 1
      OnClick = AddBClick
    end
    object DeleteB: TButton
      Left = 210
      Top = 48
      Width = 75
      Height = 25
      Caption = 'Delete'
      TabOrder = 2
      OnClick = DeleteBClick
    end
    object EditB: TButton
      Left = 210
      Top = 78
      Width = 75
      Height = 25
      Caption = 'Edit'
      TabOrder = 3
      OnClick = EditBClick
    end
  end
  object StyleGB: TGroupBox
    Left = 312
    Top = 8
    Width = 173
    Height = 235
    Caption = 'Style'
    TabOrder = 3
    object FrameB: TSpeedButton
      Left = 36
      Top = 18
      Width = 125
      Height = 25
      Caption = 'Frame'
      Margin = 3
      OnClick = FrameBClick
    end
    object FillB: TSpeedButton
      Left = 36
      Top = 48
      Width = 125
      Height = 25
      Caption = 'Fill'
      Margin = 3
      OnClick = FillBClick
    end
    object FontB: TSpeedButton
      Left = 36
      Top = 78
      Width = 125
      Height = 25
      Caption = 'Font'
      Margin = 3
      OnClick = FontBClick
    end
    object PaintBox1: TPaintBox
      Left = 12
      Top = 156
      Width = 149
      Height = 65
      OnPaint = PaintBox1Paint
    end
    object FrameCB: TCheckBox
      Left = 12
      Top = 22
      Width = 21
      Height = 17
      TabOrder = 0
      OnClick = FrameCBClick
    end
    object FillCB: TCheckBox
      Left = 12
      Top = 52
      Width = 21
      Height = 17
      TabOrder = 1
      OnClick = FillCBClick
    end
    object FontCB: TCheckBox
      Left = 12
      Top = 82
      Width = 21
      Height = 17
      TabOrder = 2
      OnClick = FontCBClick
    end
    object VisibleCB: TCheckBox
      Left = 12
      Top = 112
      Width = 145
      Height = 17
      Caption = 'Visible'
      TabOrder = 3
      OnClick = VisibleCBClick
    end
  end
  object FontDialog1: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Left = 236
    Top = 256
  end
end
