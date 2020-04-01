object frxConnTypeEdit: TfrxConnTypeEdit
  Left = 448
  Top = 259
  BorderStyle = bsDialog
  Caption = 'Database type'
  ClientHeight = 178
  ClientWidth = 331
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 160
    Top = 144
    Width = 75
    Height = 25
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 0
  end
  object Button2: TButton
    Left = 244
    Top = 144
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 313
    Height = 125
    Caption = ' Select database type '
    TabOrder = 2
    object ADOCB: TRadioButton
      Tag = 1
      Left = 32
      Top = 36
      Width = 253
      Height = 17
      Caption = 'ADO Database'
      Checked = True
      TabOrder = 0
      TabStop = True
    end
    object FIBCB: TRadioButton
      Tag = 1
      Left = 32
      Top = 76
      Width = 113
      Height = 17
      Caption = 'Firebird/Interbase'
      TabOrder = 1
    end
  end
end
