object frxBarcodeEditorForm: TfrxBarcodeEditorForm
  Left = 288
  Top = 147
  BorderStyle = bsDialog
  Caption = 'Barcode editor'
  ClientHeight = 244
  ClientWidth = 515
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
    Top = 50
    Width = 56
    Height = 13
    Caption = 'Type of Bar'
  end
  object ExampleBvl: TBevel
    Left = 260
    Top = 8
    Width = 249
    Height = 230
  end
  object ExamplePB: TPaintBox
    Left = 264
    Top = 11
    Width = 241
    Height = 223
    OnPaint = ExamplePBPaint
  end
  object CancelB: TButton
    Left = 176
    Top = 215
    Width = 72
    Height = 24
    HelpContext = 50
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 3
  end
  object OkB: TButton
    Left = 99
    Top = 215
    Width = 72
    Height = 24
    HelpContext = 40
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 2
  end
  object CodeE: TfrxComboEdit
    Left = 8
    Top = 23
    Width = 241
    Height = 20
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
    Top = 65
    Width = 241
    Height = 21
    HelpContext = 261
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 1
    OnChange = ExamplePBPaint
  end
  object OptionsLbl: TGroupBox
    Left = 8
    Top = 96
    Width = 241
    Height = 62
    Caption = 'Options'
    TabOrder = 4
    object ZoomLbl: TLabel
      Left = 147
      Top = 21
      Width = 30
      Height = 13
      Alignment = taRightJustify
      Caption = 'Zoom:'
      FocusControl = ZoomE
    end
    object CalcCheckSumCB: TCheckBox
      Left = 8
      Top = 19
      Width = 127
      Height = 16
      HelpContext = 262
      Caption = 'Calc Checksum '
      TabOrder = 0
      OnClick = ExamplePBPaint
    end
    object ViewTextCB: TCheckBox
      Left = 8
      Top = 38
      Width = 127
      Height = 16
      HelpContext = 263
      Caption = 'Text'
      TabOrder = 1
      OnClick = ExamplePBPaint
    end
    object ZoomE: TEdit
      Left = 187
      Top = 18
      Width = 32
      Height = 25
      HelpContext = 149
      TabOrder = 2
      Text = '1'
    end
    object UpDown1: TUpDown
      Left = 219
      Top = 18
      Width = 15
      Height = 19
      Associate = ZoomE
      Position = 1
      TabOrder = 3
    end
  end
  object RotationLbl: TGroupBox
    Left = 8
    Top = 164
    Width = 241
    Height = 43
    Caption = 'Rotation'
    TabOrder = 5
    object Rotation0RB: TRadioButton
      Left = 8
      Top = 19
      Width = 35
      Height = 16
      HelpContext = 264
      Caption = '0'#176
      Checked = True
      TabOrder = 0
      TabStop = True
      OnClick = ExamplePBPaint
    end
    object Rotation90RB: TRadioButton
      Left = 69
      Top = 19
      Width = 35
      Height = 16
      HelpContext = 264
      Caption = '90'#176
      TabOrder = 1
      OnClick = ExamplePBPaint
    end
    object Rotation180RB: TRadioButton
      Left = 130
      Top = 19
      Width = 43
      Height = 16
      HelpContext = 264
      Caption = '180'#176
      TabOrder = 2
      OnClick = ExamplePBPaint
    end
    object Rotation270RB: TRadioButton
      Left = 191
      Top = 19
      Width = 43
      Height = 16
      HelpContext = 264
      Caption = '270'#176
      TabOrder = 3
      OnClick = ExamplePBPaint
    end
  end
end
