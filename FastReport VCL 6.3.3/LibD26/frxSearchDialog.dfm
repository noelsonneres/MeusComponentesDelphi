object frxSearchDialog: TfrxSearchDialog
  Left = 200
  Top = 108
  AutoSize = True
  BorderStyle = bsDialog
  Caption = 'Find text'
  ClientHeight = 206
  ClientWidth = 252
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = True
  Position = poScreenCenter
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnHide = FormHide
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object ReplacePanel: TPanel
    Left = 0
    Top = 49
    Width = 252
    Height = 52
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    Visible = False
    object ReplaceL: TLabel
      Left = 8
      Top = 4
      Width = 61
      Height = 13
      Caption = 'Replace with'
      FocusControl = ReplaceE
    end
    object ReplaceE: TEdit
      Left = 8
      Top = 20
      Width = 237
      Height = 21
      HelpContext = 98
      TabOrder = 0
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 252
    Height = 49
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object TextL: TLabel
      Left = 8
      Top = 4
      Width = 56
      Height = 13
      Caption = 'Text to find'
      FocusControl = TextE
    end
    object TextE: TEdit
      Left = 8
      Top = 20
      Width = 237
      Height = 21
      HelpContext = 98
      TabOrder = 0
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 101
    Width = 252
    Height = 105
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    object OkB: TButton
      Left = 90
      Top = 76
      Width = 75
      Height = 25
      HelpContext = 40
      Caption = 'OK'
      Default = True
      ModalResult = 1
      TabOrder = 0
    end
    object CancelB: TButton
      Left = 170
      Top = 76
      Width = 75
      Height = 25
      HelpContext = 50
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
    end
    object SearchL: TGroupBox
      Left = 8
      Top = 0
      Width = 237
      Height = 65
      Caption = 'Search options'
      TabOrder = 2
      object CaseCB: TCheckBox
        Left = 8
        Top = 40
        Width = 177
        Height = 17
        HelpContext = 107
        Caption = 'Case sensitive'
        TabOrder = 0
      end
      object TopCB: TCheckBox
        Left = 8
        Top = 20
        Width = 177
        Height = 17
        Caption = 'Search from top'
        TabOrder = 1
      end
    end
  end
end
