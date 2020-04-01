object frxBlankExportDialog: TfrxBlankExportDialog
  Tag = 9173
  Left = 318
  Top = 174
  ActiveControl = OkB
  BorderStyle = bsDialog
  Caption = 'Caption'
  ClientHeight = 264
  ClientWidth = 280
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = True
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object OkB: TButton
    Tag = 1
    Left = 116
    Top = 231
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 2
  end
  object CancelB: TButton
    Tag = 2
    Left = 197
    Top = 231
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 3
  end
  object GroupPageRange: TGroupBox
    Tag = 7
    Left = 4
    Top = 4
    Width = 269
    Height = 121
    Caption = 'Page range'
    TabOrder = 0
    object DescrL: TLabel
      Tag = 9
      Left = 12
      Top = 82
      Width = 249
      Height = 29
      AutoSize = False
      Caption = 'Enter page numbers...'
      WordWrap = True
    end
    object AllRB: TRadioButton
      Tag = 3
      Left = 12
      Top = 20
      Width = 153
      Height = 17
      HelpContext = 108
      Caption = 'All'
      Checked = True
      TabOrder = 0
      TabStop = True
    end
    object CurPageRB: TRadioButton
      Tag = 4
      Left = 12
      Top = 40
      Width = 153
      Height = 17
      HelpContext = 118
      Caption = 'Current page'
      TabOrder = 1
    end
    object PageNumbersRB: TRadioButton
      Tag = 5
      Left = 12
      Top = 59
      Width = 77
      Height = 17
      HelpContext = 124
      Caption = 'Pages'
      TabOrder = 2
    end
    object PageNumbersE: TEdit
      Left = 92
      Top = 58
      Width = 165
      Height = 21
      HelpContext = 133
      TabOrder = 3
      OnChange = PageNumbersEChange
      OnKeyPress = PageNumbersEKeyPress
    end
  end
  object gbOptions: TGroupBox
    Tag = 9153
    Left = 3
    Top = 131
    Width = 269
    Height = 78
    Caption = 'Settings'
    TabOrder = 1
    object OpenCB: TCheckBox
      Tag = 8706
      Left = 12
      Top = 24
      Width = 125
      Height = 17
      Caption = 'Open after export'
      TabOrder = 1
    end
    object cbPreciseQuality: TCheckBox
      Tag = 8502
      Left = 12
      Top = 47
      Width = 125
      Height = 17
      Caption = 'Good quality'
      Checked = True
      State = cbChecked
      TabOrder = 0
    end
  end
  object sd: TSaveDialog
    Left = 144
    Top = 16
  end
end
