object frxEULAConfirmForm: TfrxEULAConfirmForm
  Left = 192
  Top = 124
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'License agreement'
  ClientHeight = 442
  ClientWidth = 490
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object RichEdit1: TRichEdit
    Left = 0
    Top = 0
    Width = 489
    Height = 377
    HideScrollBars = False
    Lines.Strings = (
      'RichEdit1')
    ScrollBars = ssVertical
    TabOrder = 0
    WordWrap = False
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 381
    Width = 489
    Height = 61
    TabOrder = 1
    object AcceptBtn: TButton
      Left = 136
      Top = 24
      Width = 75
      Height = 25
      Caption = 'Accept'
      ModalResult = 1
      TabOrder = 0
    end
    object DeclineBtn: TButton
      Left = 280
      Top = 24
      Width = 75
      Height = 25
      Caption = 'Decline'
      ModalResult = 2
      TabOrder = 1
    end
  end
end
