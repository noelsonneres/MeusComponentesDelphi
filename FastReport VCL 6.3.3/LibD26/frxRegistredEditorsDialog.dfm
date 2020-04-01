object frxRegEditorsDialog: TfrxRegEditorsDialog
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Editors configurator'
  ClientHeight = 416
  ClientWidth = 438
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object CancelBTN: TButton
    Left = 272
    Top = 384
    Width = 75
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 0
  end
  object OkBTN: TButton
    Left = 359
    Top = 384
    Width = 75
    Height = 25
    Caption = 'Ok'
    ModalResult = 1
    TabOrder = 1
  end
  object BackPanel: TPanel
    Left = 1
    Top = 0
    Width = 435
    Height = 383
    Caption = 'BackPanel'
    TabOrder = 2
    object ComponentsLB: TListBox
      Left = 3
      Top = 2
      Width = 121
      Height = 376
      ItemHeight = 13
      TabOrder = 0
      OnClick = ComponentsLBClick
    end
    object EditorsVL: TValueListEditor
      Left = 127
      Top = 2
      Width = 306
      Height = 376
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goAlwaysShowEditor, goThumbTracking]
      TabOrder = 1
      TitleCaptions.Strings = (
        'Editor'
        'Visibility')
      OnDrawCell = EditorsVLDrawCell
      OnSelectCell = EditorsVLSelectCell
      ColWidths = (
        150
        150)
    end
    object ComboPanel: TPanel
      Left = 139
      Top = 30
      Width = 15
      Height = 15
      TabOrder = 2
      Visible = False
      object ComboBtn: TSpeedButton
        Left = 0
        Top = 0
        Width = 15
        Height = 15
        Glyph.Data = {
          C6000000424DC60000000000000076000000280000000A0000000A0000000100
          0400000000005000000000000000000000001000000010000000000000000000
          80000080000000808000800000008000800080800000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777700
          0000777777777700000077777777770000007777077777000000777000777700
          0000770000077700000070000000770000007777777777000000777777777700
          00007777777777000000}
        Margin = 0
        OnClick = ComboBtnClick
      end
    end
  end
end
