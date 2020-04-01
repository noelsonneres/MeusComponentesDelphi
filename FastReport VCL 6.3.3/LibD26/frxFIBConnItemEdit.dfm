object frxFIBConnItem: TfrxFIBConnItem
  Left = 386
  Top = 368
  BorderStyle = bsDialog
  Caption = 'Edit Firebird/Interbase connection'
  ClientHeight = 389
  ClientWidth = 567
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
  object NameL: TLabel
    Left = 20
    Top = 12
    Width = 245
    Height = 13
    AutoSize = False
    Caption = 'Connection name '
  end
  object OKB: TButton
    Left = 392
    Top = 352
    Width = 75
    Height = 25
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 0
  end
  object CancelB: TButton
    Left = 480
    Top = 352
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object GroupBox1: TGroupBox
    Left = 12
    Top = 56
    Width = 545
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
  object NameE: TEdit
    Left = 16
    Top = 28
    Width = 537
    Height = 21
    TabOrder = 3
  end
  object GroupBox2: TGroupBox
    Left = 12
    Top = 140
    Width = 545
    Height = 201
    Caption = 'Connection properties'
    TabOrder = 4
    object Label1: TLabel
      Left = 12
      Top = 168
      Width = 85
      Height = 13
      AutoSize = False
      Caption = 'Cleint library'
    end
    object RoleL: TLabel
      Left = 12
      Top = 140
      Width = 85
      Height = 13
      AutoSize = False
      Caption = 'Role'
    end
    object PasswordL: TLabel
      Left = 12
      Top = 112
      Width = 85
      Height = 13
      AutoSize = False
      Caption = 'Password'
    end
    object UserNameL: TLabel
      Left = 12
      Top = 84
      Width = 85
      Height = 13
      AutoSize = False
      Caption = 'User name'
    end
    object AliasL: TLabel
      Left = 12
      Top = 56
      Width = 85
      Height = 13
      AutoSize = False
      Caption = 'Alias'
    end
    object BaseL: TLabel
      Left = 12
      Top = 28
      Width = 85
      Height = 13
      AutoSize = False
      Caption = 'Database'
    end
    object AddL: TLabel
      Left = 288
      Top = 56
      Width = 241
      Height = 13
      AutoSize = False
      Caption = 'Additional connect parameters'
    end
    object BaseE: TEdit
      Left = 100
      Top = 24
      Width = 385
      Height = 21
      TabOrder = 0
    end
    object AliasE: TEdit
      Left = 100
      Top = 52
      Width = 173
      Height = 21
      TabOrder = 1
    end
    object UserNameE: TEdit
      Left = 100
      Top = 80
      Width = 173
      Height = 21
      TabOrder = 2
    end
    object PasswordE: TEdit
      Left = 100
      Top = 108
      Width = 173
      Height = 21
      PasswordChar = '*'
      TabOrder = 3
    end
    object RoleE: TEdit
      Left = 100
      Top = 136
      Width = 173
      Height = 21
      TabOrder = 4
    end
    object LibE: TEdit
      Left = 100
      Top = 164
      Width = 385
      Height = 21
      TabOrder = 5
    end
    object LibB: TButton
      Left = 492
      Top = 164
      Width = 43
      Height = 21
      Caption = '...'
      TabOrder = 6
      OnClick = LibBClick
    end
    object AddM: TMemo
      Left = 284
      Top = 80
      Width = 249
      Height = 77
      TabOrder = 7
    end
    object BaseB: TButton
      Left = 492
      Top = 24
      Width = 43
      Height = 21
      Caption = '...'
      TabOrder = 8
      OnClick = BaseBClick
    end
  end
  object BaseDlg: TOpenDialog
    DefaultExt = '.gdb'
    Filter = 
      'InterBase database (*.gdb)|*.gdb|FireBird database (*.fdb)|*.fdb' +
      '|InterBase 7.0 database (*.ib)|*.ib'
    Left = 464
    Top = 188
  end
  object ClientDlg: TOpenDialog
    DefaultExt = '.dll'
    Filter = 'Client library (*.dll)|*.dll'
    Left = 500
    Top = 188
  end
end
