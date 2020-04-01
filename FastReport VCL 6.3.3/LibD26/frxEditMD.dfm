object frxMDEditorForm: TfrxMDEditorForm
  Left = 200
  Top = 108
  BorderStyle = bsDialog
  Caption = 'Master-Detail link'
  ClientHeight = 250
  ClientWidth = 324
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  OnHide = FormHide
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 4
    Top = 8
    Width = 55
    Height = 13
    Caption = 'Detail fields'
    FocusControl = DetailLB
  end
  object Label2: TLabel
    Left = 204
    Top = 8
    Width = 61
    Height = 13
    Caption = 'Master fields'
    FocusControl = MasterLB
  end
  object Label3: TLabel
    Left = 4
    Top = 120
    Width = 58
    Height = 13
    Caption = 'Linked fields'
    FocusControl = LinksLB
  end
  object Bevel1: TBevel
    Left = 4
    Top = 208
    Width = 317
    Height = 2
  end
  object DetailLB: TListBox
    Left = 4
    Top = 24
    Width = 115
    Height = 85
    HelpContext = 137
    Style = lbOwnerDrawFixed
    ItemHeight = 13
    TabOrder = 0
    OnClick = DetailLBClick
  end
  object MasterLB: TListBox
    Left = 204
    Top = 24
    Width = 115
    Height = 85
    HelpContext = 146
    ItemHeight = 13
    TabOrder = 1
    OnClick = MasterLBClick
  end
  object AddB: TButton
    Left = 124
    Top = 24
    Width = 75
    Height = 25
    HelpContext = 156
    Caption = 'Add'
    Enabled = False
    TabOrder = 2
    OnClick = AddBClick
  end
  object LinksLB: TListBox
    Left = 4
    Top = 136
    Width = 235
    Height = 61
    HelpContext = 164
    ItemHeight = 13
    TabOrder = 3
  end
  object ClearB: TButton
    Left = 244
    Top = 136
    Width = 75
    Height = 25
    HelpContext = 174
    Caption = 'Clear'
    TabOrder = 4
    OnClick = ClearBClick
  end
  object OkB: TButton
    Left = 164
    Top = 220
    Width = 75
    Height = 25
    HelpContext = 40
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 5
  end
  object CancelB: TButton
    Left = 244
    Top = 220
    Width = 75
    Height = 25
    HelpContext = 50
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 6
  end
end
