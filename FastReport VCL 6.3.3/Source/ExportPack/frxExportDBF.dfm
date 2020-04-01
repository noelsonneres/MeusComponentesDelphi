object frxDBFExportDialog: TfrxDBFExportDialog
  Left = 318
  Top = 174
  ActiveControl = OkB
  BorderStyle = bsDialog
  Caption = 'Export to DBF'
  ClientHeight = 455
  ClientWidth = 277
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
    Left = 113
    Top = 422
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object CancelB: TButton
    Left = 194
    Top = 422
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object GroupPageRange: TGroupBox
    Left = 4
    Top = 4
    Width = 269
    Height = 121
    Caption = ' Page range  '
    TabOrder = 2
    object DescrL: TLabel
      Left = 12
      Top = 82
      Width = 249
      Height = 29
      AutoSize = False
      Caption = 
        'Enter page numbers and/or page ranges, separated by commas. For ' +
        'example, 1,3,5-12'
      WordWrap = True
    end
    object AllRB: TRadioButton
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
      Left = 12
      Top = 40
      Width = 153
      Height = 17
      HelpContext = 118
      Caption = 'Current page'
      TabOrder = 1
    end
    object PageNumbersRB: TRadioButton
      Left = 12
      Top = 60
      Width = 77
      Height = 17
      HelpContext = 124
      Caption = 'Pages:'
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
  object GroupQuality: TGroupBox
    Left = 4
    Top = 131
    Width = 269
    Height = 262
    Caption = ' Export properties '
    TabOrder = 3
    object OEMCB: TCheckBox
      Left = 12
      Top = 20
      Width = 121
      Height = 17
      Caption = 'OEM codepage'
      Checked = True
      State = cbChecked
      TabOrder = 0
    end
    object gbFNames: TGroupBox
      Left = 12
      Top = 43
      Width = 245
      Height = 206
      Caption = 'Field Names'
      TabOrder = 1
      object rbFNAuto: TRadioButton
        Left = 8
        Top = 24
        Width = 113
        Height = 17
        Caption = 'Automatically'
        Checked = True
        TabOrder = 0
        TabStop = True
      end
      object rbFNManual: TRadioButton
        Left = 8
        Top = 47
        Width = 113
        Height = 17
        Caption = 'Manually'
        TabOrder = 1
      end
      object btFNLoad: TButton
        Left = 97
        Top = 175
        Width = 136
        Height = 25
        Caption = 'Load from file'
        TabOrder = 2
        OnClick = btFNLoadClick
      end
      object mmFN: TMemo
        Left = 8
        Top = 74
        Width = 225
        Height = 95
        TabOrder = 3
      end
    end
  end
  object OpenCB: TCheckBox
    Left = 8
    Top = 399
    Width = 253
    Height = 17
    Caption = 'Open after export'
    Checked = True
    State = cbChecked
    TabOrder = 4
  end
  object sd: TSaveDialog
    DefaultExt = '.dbf'
    Filter = 'DBF file (*.dbf)|*.dbf|All files|*.*'
    Options = [ofHideReadOnly, ofNoChangeDir, ofEnableSizing]
    Left = 184
    Top = 32
  end
  object odFN: TOpenDialog
    Filter = 'Text files (*.txt)|*.txt|All files|*.*'
    Left = 120
    Top = 264
  end
end
