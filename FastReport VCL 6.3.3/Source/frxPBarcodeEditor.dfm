object frxPBarcodeEditorForm: TfrxPBarcodeEditorForm
  Left = 269
  Top = 122
  BorderStyle = bsDialog
  Caption = 'Barcode editor'
  ClientHeight = 255
  ClientWidth = 539
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
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object CodeLbl: TLabel
    Left = 8
    Top = 8
    Width = 25
    Height = 13
    Caption = 'Code'
  end
  object TypeLbl: TLabel
    Left = 8
    Top = 52
    Width = 56
    Height = 13
    Caption = 'Type of Bar'
  end
  object ExampleBvl: TBevel
    Left = 272
    Top = 8
    Width = 261
    Height = 241
  end
  object ExamplePB: TPaintBox
    Left = 276
    Top = 12
    Width = 253
    Height = 233
    OnPaint = ExamplePBPaint
  end
  object CancelB: TButton
    Left = 184
    Top = 225
    Width = 75
    Height = 25
    HelpContext = 50
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 3
  end
  object OkB: TButton
    Left = 104
    Top = 225
    Width = 75
    Height = 25
    HelpContext = 40
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 2
  end
  object CodeE: TfrxComboEdit
    Left = 8
    Top = 24
    Width = 253
    Height = 21
    HelpContext = 260
    Style = csSimple
    ItemHeight = 13
    TabOrder = 0
    Text = '0'
    Glyph.Data = {
      D6000000424DD60000000000000076000000280000000C0000000C0000000100
      0400000000006000000000000000000000001000000010000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00707777777777
      0000770777777777000077087007007700007780778007770000778087700077
      0000777087007807000077780777777700007700000777770000777708777777
      0000777700780777000077777000777700007777777777770000}
    OnButtonClick = ExprBtnClick
  end
  object TypeCB: TComboBox
    Left = 8
    Top = 68
    Width = 253
    Height = 21
    HelpContext = 261
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 1
    OnChange = ExamplePBPaint
  end
  object OptionsLbl: TGroupBox
    Left = 8
    Top = 100
    Width = 253
    Height = 65
    Caption = 'Options'
    TabOrder = 4
    object CalcCheckSumCB: TCheckBox
      Left = 8
      Top = 20
      Width = 133
      Height = 17
      HelpContext = 262
      Caption = 'Calc Checksum '
      TabOrder = 0
      OnClick = ExamplePBPaint
    end
    object ViewTextCB: TCheckBox
      Left = 8
      Top = 40
      Width = 133
      Height = 17
      HelpContext = 263
      Caption = 'Text'
      TabOrder = 1
      OnClick = ExamplePBPaint
    end
  end
  object RotationLbl: TGroupBox
    Left = 8
    Top = 172
    Width = 253
    Height = 45
    Caption = 'Rotation'
    TabOrder = 5
    object Rotation0RB: TRadioButton
      Left = 8
      Top = 20
      Width = 37
      Height = 17
      HelpContext = 264
      Caption = '0'#176
      Checked = True
      TabOrder = 0
      TabStop = True
      OnClick = ExamplePBPaint
    end
    object Rotation90RB: TRadioButton
      Left = 72
      Top = 20
      Width = 37
      Height = 17
      HelpContext = 264
      Caption = '90'#176
      TabOrder = 1
      OnClick = ExamplePBPaint
    end
    object Rotation180RB: TRadioButton
      Left = 136
      Top = 20
      Width = 45
      Height = 17
      HelpContext = 264
      Caption = '180'#176
      TabOrder = 2
      OnClick = ExamplePBPaint
    end
    object Rotation270RB: TRadioButton
      Left = 200
      Top = 20
      Width = 45
      Height = 17
      HelpContext = 264
      Caption = '270'#176
      TabOrder = 3
      OnClick = ExamplePBPaint
    end
  end
end
