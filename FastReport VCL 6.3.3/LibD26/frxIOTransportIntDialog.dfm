object frxIOTransportDialogIntForm: TfrxIOTransportDialogIntForm
  Left = 271
  Top = 169
  BorderStyle = bsDialog
  Caption = 'Form'
  ClientHeight = 374
  ClientWidth = 426
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -10
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  DesignSize = (
    426
    374)
  PixelsPerInch = 96
  TextHeight = 12
  object FileNameLabel: TLabel
    Tag = 6482
    Left = 13
    Top = 322
    Width = 47
    Height = 12
    Anchors = [akLeft, akBottom]
    Caption = 'File Name:'
  end
  object ListSB: TSpeedButton
    Left = 362
    Top = 9
    Width = 23
    Height = 22
    AllowAllUp = True
    GroupIndex = 1
    Caption = 'L'
    OnClick = IconsSBClick
  end
  object IconsSB: TSpeedButton
    Left = 391
    Top = 9
    Width = 23
    Height = 22
    AllowAllUp = True
    GroupIndex = 1
    Down = True
    Caption = 'I'
    OnClick = IconsSBClick
  end
  object RefreshSB: TSpeedButton
    Left = 333
    Top = 9
    Width = 23
    Height = 22
    Caption = 'R'
    OnClick = FormShow
  end
  object CancelB: TButton
    Tag = 2
    Left = 354
    Top = 347
    Width = 60
    Height = 20
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 4
  end
  object OkB: TButton
    Tag = 1
    Left = 282
    Top = 347
    Width = 60
    Height = 20
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 3
  end
  object FileNameEdit: TEdit
    Left = 90
    Top = 319
    Width = 324
    Height = 20
    Anchors = [akLeft, akRight, akBottom]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -10
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
  end
  object CreateDirectoryButton: TButton
    Tag = 6483
    Left = 13
    Top = 347
    Width = 129
    Height = 20
    Anchors = [akLeft, akBottom]
    Caption = 'Create Directory'
    Default = True
    TabOrder = 1
    OnClick = CreateDirectoryButtonClick
  end
  object DeleteButton: TButton
    Tag = 6484
    Left = 166
    Top = 347
    Width = 91
    Height = 20
    Anchors = [akLeft, akBottom]
    Caption = 'Delete'
    Default = True
    TabOrder = 2
    OnClick = DeleteButtonClick
  end
  object DirectoryLV: TListView
    Left = 8
    Top = 37
    Width = 406
    Height = 277
    BevelKind = bkFlat
    Columns = <>
    ColumnClick = False
    ReadOnly = True
    SortType = stText
    TabOrder = 5
    OnClick = DirectoryLVClick
    OnDblClick = DirectoryListBoxDblClick
  end
  object UpdateP: TPanel
    Left = 96
    Top = 112
    Width = 226
    Height = 110
    BevelInner = bvRaised
    BevelOuter = bvNone
    Ctl3D = True
    ParentBackground = False
    ParentCtl3D = False
    TabOrder = 6
    object UpdateL: TLabel
      Left = 74
      Top = 40
      Width = 84
      Height = 19
      Caption = 'Updating ...'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
  end
  object FillTimer: TTimer
    Enabled = False
    Interval = 2
    OnTimer = FillTimerTimer
    Left = 160
    Top = 8
  end
end
