object MapColorRangeForm: TMapColorRangeForm
  Tag = 6350
  Left = 358
  Top = 289
  ActiveControl = OkB
  BorderStyle = bsDialog
  Caption = 'MapColorRangeForm'
  ClientHeight = 240
  ClientWidth = 485
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  DesignSize = (
    485
    240)
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 280
    Top = 8
    Width = 197
    Height = 109
    Shape = bsFrame
  end
  object AutoLabel: TLabel
    Tag = 6351
    Left = 288
    Top = 12
    Width = 23
    Height = 13
    Caption = 'Auto'
  end
  object UpSpeedButton: TSpeedButton
    Left = 240
    Top = 8
    Width = 24
    Height = 23
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    OnClick = UpSpeedButtonClick
  end
  object DownSpeedButton: TSpeedButton
    Left = 240
    Top = 32
    Width = 24
    Height = 23
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    OnClick = DownSpeedButtonClick
  end
  object CollectionListBox: TListBox
    Left = 8
    Top = 8
    Width = 229
    Height = 191
    Anchors = [akLeft, akTop, akBottom]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ItemHeight = 13
    ParentFont = False
    TabOrder = 0
    OnClick = CollectionListBoxClick
  end
  object CancelB: TButton
    Tag = 2
    Left = 400
    Top = 204
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 8
  end
  object OkB: TButton
    Tag = 1
    Left = 320
    Top = 204
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 7
    OnClick = OkBClick
  end
  object ColorColorBox: TColorBox
    Left = 356
    Top = 28
    Width = 110
    Height = 22
    ItemHeight = 16
    TabOrder = 2
  end
  object StartEdit: TEdit
    Left = 356
    Top = 56
    Width = 110
    Height = 21
    TabOrder = 4
    OnChange = StartEditChange
  end
  object EndEdit: TEdit
    Left = 356
    Top = 84
    Width = 110
    Height = 21
    TabOrder = 6
    OnChange = StartEditChange
  end
  object ColorCheckBox: TCheckBox
    Tag = 6352
    Left = 292
    Top = 32
    Width = 58
    Height = 12
    Caption = 'Color'
    TabOrder = 1
    OnClick = ColorCheckBoxClick
  end
  object StartCheckBox: TCheckBox
    Tag = 6353
    Left = 292
    Top = 60
    Width = 58
    Height = 13
    Caption = 'Start'
    TabOrder = 3
    OnClick = ColorCheckBoxClick
  end
  object EndCheckBox: TCheckBox
    Tag = 6354
    Left = 292
    Top = 88
    Width = 58
    Height = 12
    Caption = 'End'
    TabOrder = 5
    OnClick = ColorCheckBoxClick
  end
  object AddButton: TButton
    Tag = 6355
    Left = 8
    Top = 204
    Width = 87
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Add'
    TabOrder = 9
    OnClick = AddButtonClick
  end
  object DeleteButton: TButton
    Tag = 6356
    Left = 100
    Top = 204
    Width = 88
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Delete'
    TabOrder = 10
    OnClick = DeleteButtonClick
  end
end
