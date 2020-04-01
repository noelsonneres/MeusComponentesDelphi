object frxDropboxIOTransportForm: TfrxDropboxIOTransportForm
  Tag = 6490
  Left = 257
  Top = 149
  BorderStyle = bsDialog
  Caption = 'TfrxDropboxSaveFilterForm'
  ClientHeight = 241
  ClientWidth = 407
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  DesignSize = (
    407
    241)
  PixelsPerInch = 96
  TextHeight = 13
  object RequiredLabel: TLabel
    Tag = 6471
    Left = 9
    Top = 221
    Width = 158
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = 'Required fields are not filled'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    Visible = False
  end
  object OkB: TButton
    Tag = 1
    Left = 246
    Top = 202
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
    OnClick = OkBClick
  end
  object CancelB: TButton
    Tag = 2
    Left = 326
    Top = 202
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object PageControl: TPageControl
    Left = 6
    Top = 6
    Width = 395
    Height = 187
    ActivePage = GeneralTabSheet
    TabOrder = 3
    object GeneralTabSheet: TTabSheet
      Tag = 6479
      Caption = 'General'
      object ClientIDLabel: TLabel
        Tag = 6491
        Left = 13
        Top = 13
        Width = 77
        Height = 13
        Caption = 'Application Key:'
      end
      object RemoteDirLabel: TLabel
        Tag = 6477
        Left = 13
        Top = 45
        Width = 57
        Height = 13
        Caption = 'Remote Dir:'
      end
      object UserNameLabel: TLabel
        Tag = 6474
        Left = 13
        Top = 104
        Width = 56
        Height = 13
        Caption = 'User Name:'
      end
      object PasswordLabel: TLabel
        Tag = 6475
        Left = 13
        Top = 133
        Width = 50
        Height = 13
        Caption = 'Password:'
      end
      object ClientIDEdit: TEdit
        Left = 134
        Top = 10
        Width = 244
        Height = 21
        TabOrder = 0
      end
      object RemoteDirComboBox: TComboBox
        Left = 134
        Top = 42
        Width = 244
        Height = 21
        ItemHeight = 13
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
      end
      object UserNameEdit: TEdit
        Left = 134
        Top = 101
        Width = 244
        Height = 21
        TabOrder = 2
      end
      object PasswordEdit: TEdit
        Left = 134
        Top = 130
        Width = 244
        Height = 21
        PasswordChar = '*'
        TabOrder = 3
      end
      object PassLoginCB: TCheckBox
        Tag = 6494
        Left = 13
        Top = 69
        Width = 356
        Height = 17
        Caption = 'Pass login to browser ( not safe )'
        TabOrder = 4
        OnClick = PassLoginCBClick
      end
    end
    object ProxyTabSheet: TTabSheet
      Tag = 6480
      Caption = 'Proxy'
      ImageIndex = 1
      object ProxyPasswordLabel: TLabel
        Tag = 6475
        Left = 13
        Top = 133
        Width = 50
        Height = 13
        Caption = 'Password:'
      end
      object ProxyUserNameLabel: TLabel
        Tag = 6474
        Left = 13
        Top = 104
        Width = 56
        Height = 13
        Caption = 'User Name:'
      end
      object ProxyPortLabel: TLabel
        Tag = 6473
        Left = 13
        Top = 74
        Width = 24
        Height = 13
        Caption = 'Port:'
      end
      object ProxyHostLabel: TLabel
        Tag = 6470
        Left = 13
        Top = 45
        Width = 56
        Height = 13
        Caption = 'Host Name:'
      end
      object ProxyPasswordEdit: TEdit
        Left = 134
        Top = 130
        Width = 122
        Height = 21
        PasswordChar = '*'
        TabOrder = 4
      end
      object ProxyUserNameEdit: TEdit
        Left = 134
        Top = 101
        Width = 122
        Height = 21
        TabOrder = 3
      end
      object ProxyPortComboBox: TComboBox
        Left = 134
        Top = 72
        Width = 122
        Height = 21
        ItemHeight = 0
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        Text = '21'
        OnKeyPress = ProxyPortComboBoxKeyPress
      end
      object ProxyHostComboBox: TComboBox
        Left = 134
        Top = 42
        Width = 244
        Height = 21
        ItemHeight = 0
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
      end
      object UseProxyServerCheckBox: TCheckBox
        Tag = 6492
        Left = 13
        Top = 15
        Width = 243
        Height = 13
        Caption = 'Use Proxy Server'
        TabOrder = 0
      end
    end
  end
  object RememberPropertiesCheckBox: TCheckBox
    Tag = 6472
    Left = 9
    Top = 202
    Width = 228
    Height = 14
    Anchors = [akLeft, akBottom]
    Caption = 'Remember Properties'
    TabOrder = 0
  end
end
