object frxOneDriveIOTransportForm: TfrxOneDriveIOTransportForm
  Tag = 6500
  Left = 284
  Top = 169
  BorderStyle = bsDialog
  Caption = 'TfrxOneDriveSaveFilterForm'
  ClientHeight = 235
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
  DesignSize = (
    407
    235)
  PixelsPerInch = 96
  TextHeight = 13
  object RequiredLabel: TLabel
    Tag = 6471
    Left = 9
    Top = 215
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
    Top = 196
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
    Top = 196
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
    Height = 181
    ActivePage = GeneralTabSheet
    TabOrder = 3
    object GeneralTabSheet: TTabSheet
      Tag = 6479
      Caption = 'General'
      object ClientIDLabel: TLabel
        Tag = 6501
        Left = 13
        Top = 13
        Width = 70
        Height = 13
        Caption = 'Application ID:'
      end
      object RemoteDirLabel: TLabel
        Tag = 6477
        Left = 13
        Top = 42
        Width = 57
        Height = 13
        Caption = 'Remote Dir:'
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
        Top = 39
        Width = 244
        Height = 21
        ItemHeight = 13
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
      end
    end
    object ProxyTabSheet: TTabSheet
      Tag = 6480
      Caption = 'Proxy'
      ImageIndex = 1
      object ProxyPasswordLabel: TLabel
        Tag = 6475
        Left = 13
        Top = 128
        Width = 50
        Height = 13
        Caption = 'Password:'
      end
      object ProxyUserNameLabel: TLabel
        Tag = 6474
        Left = 13
        Top = 99
        Width = 56
        Height = 13
        Caption = 'User Name:'
      end
      object ProxyPortLabel: TLabel
        Tag = 6473
        Left = 13
        Top = 70
        Width = 24
        Height = 13
        Caption = 'Port:'
      end
      object ProxyHostLabel: TLabel
        Tag = 6470
        Left = 13
        Top = 42
        Width = 56
        Height = 13
        Caption = 'Host Name:'
      end
      object ProxyPasswordEdit: TEdit
        Left = 134
        Top = 126
        Width = 122
        Height = 21
        PasswordChar = '*'
        TabOrder = 4
      end
      object ProxyUserNameEdit: TEdit
        Left = 134
        Top = 97
        Width = 122
        Height = 21
        TabOrder = 3
      end
      object ProxyPortComboBox: TComboBox
        Left = 134
        Top = 68
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
        Top = 39
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
        Top = 13
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
    Top = 196
    Width = 236
    Height = 14
    Anchors = [akLeft, akBottom]
    Caption = 'Remember Properties'
    TabOrder = 0
  end
end
