object frxConnectionItemEdit: TfrxConnectionItemEdit
  Left = 447
  Top = 328
  BorderStyle = bsDialog
  Caption = 'Edit connection'
  ClientHeight = 225
  ClientWidth = 445
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object ConnL: TLabel
    Left = 12
    Top = 56
    Width = 169
    Height = 13
    AutoSize = False
    Caption = 'Connection string'
  end
  object NameL: TLabel
    Left = 12
    Top = 12
    Width = 245
    Height = 13
    AutoSize = False
    Caption = 'Connection name '
  end
  object Panel1: TPanel
    Left = 0
    Top = 182
    Width = 445
    Height = 43
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 3
    object OkB: TButton
      Left = 264
      Top = 8
      Width = 75
      Height = 25
      Caption = 'OK'
      ModalResult = 1
      TabOrder = 0
    end
    object CancelB: TButton
      Left = 352
      Top = 8
      Width = 75
      Height = 25
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
    end
  end
  object ConnE: TEdit
    Left = 8
    Top = 72
    Width = 381
    Height = 21
    TabOrder = 1
  end
  object ConnB: TButton
    Left = 392
    Top = 72
    Width = 41
    Height = 21
    Caption = '...'
    TabOrder = 4
    OnClick = ConnBClick
  end
  object NameE: TEdit
    Left = 8
    Top = 28
    Width = 425
    Height = 21
    TabOrder = 0
  end
  object GroupBox1: TGroupBox
    Left = 12
    Top = 104
    Width = 421
    Height = 73
    Caption = 'Connection type'
    TabOrder = 2
    object SystemRB: TRadioButton
      Tag = 1
      Left = 16
      Top = 21
      Width = 145
      Height = 16
      Hint = 'Should be used for FastReport Server, Scheduler, etc'
      Caption = 'System connection'
      Checked = True
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      TabStop = True
    end
    object UserRB: TRadioButton
      Tag = 1
      Left = 16
      Top = 45
      Width = 169
      Height = 16
      Hint = 'Generic applications'
      Caption = 'User connection'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
    end
  end
end
