object frxFormatEditorForm: TfrxFormatEditorForm
  Left = 196
  Top = 109
  BorderStyle = bsDialog
  Caption = 'Display Format'
  ClientHeight = 291
  ClientWidth = 301
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnHide = FormHide
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object ExpressionL: TLabel
    Left = 8
    Top = 11
    Width = 56
    Height = 13
    Caption = 'Expression:'
  end
  object CategoryL: TLabel
    Left = 8
    Top = 44
    Width = 49
    Height = 13
    Caption = 'Category:'
  end
  object FormatL: TLabel
    Left = 156
    Top = 44
    Width = 38
    Height = 13
    Caption = 'Format:'
  end
  object OkB: TButton
    Left = 138
    Top = 256
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object CancelB: TButton
    Left = 218
    Top = 256
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 170
    Width = 285
    Height = 73
    TabOrder = 2
    object FormatStrL: TLabel
      Left = 8
      Top = 16
      Width = 68
      Height = 13
      Caption = 'Format string:'
    end
    object SeparatorL: TLabel
      Left = 8
      Top = 44
      Width = 90
      Height = 13
      Caption = 'Decimal separator:'
    end
    object FormatE: TEdit
      Left = 152
      Top = 12
      Width = 123
      Height = 21
      TabOrder = 0
    end
    object SeparatorE: TEdit
      Left = 152
      Top = 40
      Width = 25
      Height = 21
      TabOrder = 1
      Text = ','
    end
  end
  object ComboBox1: TComboBox
    Left = 104
    Top = 8
    Width = 189
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 3
    OnChange = ComboBox1Change
  end
  object FormatLB: TListBox
    Left = 156
    Top = 60
    Width = 137
    Height = 101
    Style = lbOwnerDrawFixed
    ItemHeight = 13
    TabOrder = 4
    OnClick = FormatLBClick
    OnDrawItem = FormatLBDrawItem
  end
  object CategoryLB: TListBox
    Left = 8
    Top = 60
    Width = 137
    Height = 101
    ItemHeight = 13
    TabOrder = 5
    OnClick = CategoryLBClick
  end
end
