object frxFrameEditorForm: TfrxFrameEditorForm
  Left = 339
  Top = 330
  BorderStyle = bsDialog
  Caption = 'Edit Frame'
  ClientHeight = 336
  ClientWidth = 333
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  ShowHint = True
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object HintL: TLabel
    Left = 8
    Top = 260
    Width = 317
    Height = 33
    AutoSize = False
    Caption = '1'#13#10'2'
    WordWrap = True
  end
  object OkB: TButton
    Left = 170
    Top = 304
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object CancelB: TButton
    Left = 250
    Top = 304
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object FrameGB: TGroupBox
    Left = 140
    Top = 4
    Width = 185
    Height = 249
    Caption = 'Frame'
    TabOrder = 2
    object FrameAllB: TSpeedButton
      Left = 12
      Top = 20
      Width = 24
      Height = 24
      OnClick = FrameAllBClick
    end
    object FrameNoB: TSpeedButton
      Left = 36
      Top = 20
      Width = 24
      Height = 24
      OnClick = FrameNoBClick
    end
    object FrameTopB: TSpeedButton
      Left = 76
      Top = 20
      Width = 24
      Height = 24
      AllowAllUp = True
      GroupIndex = 1
      OnClick = FrameLineClick
    end
    object FrameBottomB: TSpeedButton
      Left = 100
      Top = 20
      Width = 24
      Height = 24
      AllowAllUp = True
      GroupIndex = 2
      OnClick = FrameLineClick
    end
    object FrameLeftB: TSpeedButton
      Left = 124
      Top = 20
      Width = 24
      Height = 24
      AllowAllUp = True
      GroupIndex = 3
      OnClick = FrameLineClick
    end
    object FrameRightB: TSpeedButton
      Left = 148
      Top = 20
      Width = 24
      Height = 24
      AllowAllUp = True
      GroupIndex = 4
      OnClick = FrameLineClick
    end
    object ShadowWidthL: TLabel
      Left = 12
      Top = 200
      Width = 32
      Height = 13
      Caption = 'Width:'
    end
    object ShadowColorL: TLabel
      Left = 100
      Top = 200
      Width = 29
      Height = 13
      Caption = 'Color:'
    end
    object ShadowCB: TCheckBox
      Left = 12
      Top = 176
      Width = 97
      Height = 17
      Caption = 'Shadow'
      TabOrder = 0
      OnClick = ShadowCBClick
    end
    object ShadowWidthCB: TComboBox
      Left = 12
      Top = 216
      Width = 73
      Height = 21
      ItemHeight = 13
      TabOrder = 1
      Text = 'ShadowWidthCB'
      OnChange = ShadowWidthCBChange
      Items.Strings = (
        '0,1'
        '0,5'
        '1'
        '1,5'
        '2'
        '3'
        '4'
        '5')
    end
  end
  object LineGB: TGroupBox
    Left = 8
    Top = 4
    Width = 125
    Height = 249
    Caption = 'Line'
    TabOrder = 3
    object LineStyleL: TLabel
      Left = 12
      Top = 20
      Width = 28
      Height = 13
      Caption = 'Style:'
    end
    object LineWidthL: TLabel
      Left = 12
      Top = 156
      Width = 32
      Height = 13
      Caption = 'Width:'
    end
    object LineColorL: TLabel
      Left = 12
      Top = 200
      Width = 29
      Height = 13
      Caption = 'Color:'
    end
    object LineWidthCB: TComboBox
      Left = 12
      Top = 172
      Width = 98
      Height = 21
      ItemHeight = 13
      TabOrder = 0
      Text = 'LineWidthCB'
      Items.Strings = (
        '0,1'
        '0,5'
        '1'
        '1,5'
        '2'
        '3'
        '4'
        '5')
    end
  end
end
