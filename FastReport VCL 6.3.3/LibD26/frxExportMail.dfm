object frxMailExportDialog: TfrxMailExportDialog
  Left = 325
  Top = 253
  ActiveControl = OkB
  BorderStyle = bsDialog
  Caption = 'Export to e-mail'
  ClientHeight = 397
  ClientWidth = 397
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
  object ReqLB: TLabel
    Left = 8
    Top = 371
    Width = 225
    Height = 13
    AutoSize = False
    Caption = 'Required fields are not filled'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    Visible = False
  end
  object OkB: TButton
    Left = 238
    Top = 367
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
    OnClick = OkBClick
  end
  object CancelB: TButton
    Left = 318
    Top = 367
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object PageControl1: TPageControl
    Left = 4
    Top = 5
    Width = 389
    Height = 356
    ActivePage = ExportSheet
    TabOrder = 2
    OnChange = PageControl1Change
    object ExportSheet: TTabSheet
      Caption = 'E-mail details'
      object MessageGroup: TGroupBox
        Left = 4
        Top = 4
        Width = 373
        Height = 221
        Caption = 'Message'
        TabOrder = 0
        object AddressLB: TLabel
          Left = 8
          Top = 20
          Width = 65
          Height = 13
          AutoSize = False
          Caption = 'Address'
        end
        object SubjectLB: TLabel
          Left = 8
          Top = 44
          Width = 65
          Height = 13
          AutoSize = False
          Caption = 'Subject'
        end
        object MessageLB: TLabel
          Left = 8
          Top = 68
          Width = 65
          Height = 13
          AutoSize = False
          Caption = 'Text'
        end
        object MessageM: TMemo
          Left = 76
          Top = 64
          Width = 285
          Height = 131
          ScrollBars = ssBoth
          TabOrder = 2
        end
        object AddressE: TComboBox
          Left = 76
          Top = 16
          Width = 285
          Height = 21
          Hint = 'Address or addresses delimited by comma'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
        end
        object SubjectE: TComboBox
          Left = 76
          Top = 40
          Width = 285
          Height = 21
          TabOrder = 1
        end
        object ReadingCB: TCheckBox
          Left = 76
          Top = 199
          Width = 285
          Height = 17
          Caption = 'Confirmation Reading '
          TabOrder = 3
        end
      end
      object AttachGroup: TGroupBox
        Left = 4
        Top = 228
        Width = 373
        Height = 101
        Caption = 'Attached export'
        TabOrder = 1
        object FormatLB: TLabel
          Left = 12
          Top = 24
          Width = 73
          Height = 13
          AutoSize = False
          Caption = 'Format'
        end
        object MailTransportLB: TLabel
          Left = 12
          Top = 53
          Width = 77
          Height = 13
          Caption = 'Mail transport:'
        end
        object ExportsCombo: TComboBox
          Left = 92
          Top = 20
          Width = 269
          Height = 21
          TabOrder = 0
        end
        object SettingCB: TCheckBox
          Left = 16
          Top = 76
          Width = 345
          Height = 17
          Caption = 'Advanced export settings'
          Checked = True
          State = cbChecked
          TabOrder = 1
        end
        object Radio_MAPI: TRadioButton
          Left = 160
          Top = 51
          Width = 59
          Height = 17
          Caption = 'MAPI'
          TabOrder = 2
        end
        object Radio_Outlook: TRadioButton
          Left = 225
          Top = 51
          Width = 77
          Height = 17
          Caption = 'MS Outlook'
          TabOrder = 3
        end
        object Radio_SMTP: TRadioButton
          Left = 97
          Top = 51
          Width = 57
          Height = 17
          Caption = 'SMTP'
          Checked = True
          TabOrder = 4
          TabStop = True
        end
      end
    end
    object AccountSheet: TTabSheet
      Caption = 'Account properties'
      ImageIndex = 1
      object MailGroup: TGroupBox
        Left = 4
        Top = 4
        Width = 373
        Height = 197
        Caption = 'Mail'
        TabOrder = 0
        object FromNameLB: TLabel
          Left = 8
          Top = 20
          Width = 101
          Height = 13
          AutoSize = False
          Caption = 'From Name'
        end
        object FromAddrLB: TLabel
          Left = 8
          Top = 44
          Width = 101
          Height = 13
          AutoSize = False
          Caption = 'From Address'
        end
        object OrgLB: TLabel
          Left = 8
          Top = 68
          Width = 101
          Height = 13
          AutoSize = False
          Caption = 'Organization'
        end
        object SignatureLB: TLabel
          Left = 8
          Top = 92
          Width = 101
          Height = 13
          AutoSize = False
          Caption = 'Signature'
        end
        object FromNameE: TEdit
          Left = 112
          Top = 16
          Width = 249
          Height = 21
          TabOrder = 0
        end
        object FromAddrE: TEdit
          Left = 112
          Top = 40
          Width = 249
          Height = 21
          TabOrder = 1
        end
        object OrgE: TEdit
          Left = 112
          Top = 64
          Width = 249
          Height = 21
          TabOrder = 2
        end
        object SignatureM: TMemo
          Left = 112
          Top = 88
          Width = 249
          Height = 97
          ScrollBars = ssVertical
          TabOrder = 3
        end
        object SignBuildBtn: TButton
          Left = 8
          Top = 108
          Width = 67
          Height = 21
          Caption = 'Build'
          TabOrder = 4
          OnClick = SignBuildBtnClick
        end
      end
      object RememberCB: TCheckBox
        Left = 4
        Top = 288
        Width = 293
        Height = 17
        Caption = 'Remember properties'
        TabOrder = 2
      end
      object AccountGroup: TGroupBox
        Left = 4
        Top = 204
        Width = 373
        Height = 77
        Caption = 'Account'
        TabOrder = 1
        object HostLB: TLabel
          Left = 8
          Top = 20
          Width = 40
          Height = 13
          AutoSize = False
          Caption = 'Host'
        end
        object PortLB: TLabel
          Left = 272
          Top = 20
          Width = 53
          Height = 13
          AutoSize = False
          Caption = 'Port'
        end
        object LoginLB: TLabel
          Left = 8
          Top = 48
          Width = 40
          Height = 13
          AutoSize = False
          Caption = 'Login'
        end
        object PasswordLB: TLabel
          Left = 136
          Top = 48
          Width = 61
          Height = 13
          AutoSize = False
          Caption = 'Password'
        end
        object TimeoutLB: TLabel
          Left = 269
          Top = 47
          Width = 53
          Height = 13
          AutoSize = False
          Caption = 'Time out'
        end
        object HostE: TEdit
          Left = 48
          Top = 17
          Width = 213
          Height = 21
          TabOrder = 0
        end
        object PortE: TEdit
          Left = 328
          Top = 16
          Width = 33
          Height = 21
          TabOrder = 1
          Text = '25'
          OnKeyPress = PortEKeyPress
        end
        object LoginE: TEdit
          Left = 48
          Top = 44
          Width = 73
          Height = 21
          TabOrder = 2
        end
        object PasswordE: TEdit
          Left = 188
          Top = 44
          Width = 73
          Height = 21
          PasswordChar = '*'
          TabOrder = 3
        end
        object TimeoutE: TEdit
          Left = 328
          Top = 43
          Width = 33
          Height = 21
          TabOrder = 4
          Text = '60'
          OnKeyPress = PortEKeyPress
        end
      end
    end
  end
end
