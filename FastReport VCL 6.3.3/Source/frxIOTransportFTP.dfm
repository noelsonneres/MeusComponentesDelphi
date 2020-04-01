object frxFTPIOTransportForm: TfrxFTPIOTransportForm
  Tag = 6478
  Left = 440
  Top = 47
  BorderStyle = bsDialog
  Caption = 'frxFTPSaveFilterForm'
  ClientHeight = 287
  ClientWidth = 403
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  DesignSize = (
    403
    287)
  PixelsPerInch = 96
  TextHeight = 13
  object RequiredLabel: TLabel
    Tag = 6471
    Left = 11
    Top = 269
    Width = 158
    Height = 13
    Anchors = []
    Caption = 'Required fields are not filled'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    Visible = False
  end
  object CancelB: TButton
    Tag = 2
    Left = 322
    Top = 254
    Width = 75
    Height = 25
    Anchors = []
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object OkB: TButton
    Tag = 1
    Left = 243
    Top = 254
    Width = 75
    Height = 25
    Anchors = []
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
    OnClick = OkBClick
  end
  object RememberPropertiesCheckBox: TCheckBox
    Tag = 6472
    Left = 8
    Top = 253
    Width = 233
    Height = 13
    Anchors = []
    Caption = 'Remember Properties'
    TabOrder = 0
  end
  object PageControl: TPageControl
    Left = 6
    Top = 6
    Width = 391
    Height = 238
    ActivePage = GeneralTabSheet
    TabOrder = 3
    object GeneralTabSheet: TTabSheet
      Tag = 6479
      Caption = 'General'
      object HostLabel: TLabel
        Tag = 6470
        Left = 13
        Top = 13
        Width = 56
        Height = 13
        Caption = 'Host Name:'
      end
      object PortLabel: TLabel
        Tag = 6473
        Left = 13
        Top = 42
        Width = 24
        Height = 13
        Caption = 'Port:'
      end
      object UserNameLabel: TLabel
        Tag = 6474
        Left = 13
        Top = 70
        Width = 56
        Height = 13
        Caption = 'User Name:'
      end
      object PasswordLabel: TLabel
        Tag = 6475
        Left = 13
        Top = 99
        Width = 50
        Height = 13
        Caption = 'Password:'
      end
      object RemoteDirLabel: TLabel
        Tag = 6477
        Left = 13
        Top = 157
        Width = 57
        Height = 13
        Caption = 'Remote Dir:'
      end
      object HostComboBox: TComboBox
        Left = 134
        Top = 10
        Width = 244
        Height = 21
        ItemHeight = 13
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
      end
      object PortComboBox: TComboBox
        Left = 134
        Top = 39
        Width = 122
        Height = 21
        ItemHeight = 13
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        Text = '21'
        OnKeyPress = PortComboBoxKeyPress
      end
      object PasswordEdit: TEdit
        Left = 134
        Top = 97
        Width = 122
        Height = 21
        PasswordChar = '*'
        TabOrder = 3
      end
      object UserNameEdit: TEdit
        Left = 134
        Top = 68
        Width = 122
        Height = 21
        TabOrder = 2
      end
      object PassiveCheckBox: TCheckBox
        Tag = 6476
        Left = 13
        Top = 128
        Width = 243
        Height = 14
        Caption = 'Passive'
        TabOrder = 4
      end
      object RemoteDirComboBox: TComboBox
        Left = 134
        Top = 157
        Width = 244
        Height = 21
        ItemHeight = 13
        ParentShowHint = False
        ShowHint = True
        TabOrder = 5
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
      object ProxyTypeLabel: TLabel
        Tag = 6481
        Left = 13
        Top = 13
        Width = 59
        Height = 13
        Caption = 'Proxy Type:'
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
        ItemHeight = 13
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        Text = '21'
        OnKeyPress = PortComboBoxKeyPress
      end
      object ProxyHostComboBox: TComboBox
        Left = 134
        Top = 39
        Width = 244
        Height = 21
        ItemHeight = 13
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
      end
      object ProxyTypeComboBox: TComboBox
        Left = 134
        Top = 10
        Width = 244
        Height = 21
        Style = csDropDownList
        DropDownCount = 10
        ItemHeight = 13
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
      end
    end
  end
end
