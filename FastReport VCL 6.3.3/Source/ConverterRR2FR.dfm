object RaveLoaderForm: TRaveLoaderForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Rave Import'
  ClientHeight = 82
  ClientWidth = 341
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object lb: TLabel
    Left = 8
    Top = 8
    Width = 8
    Height = 13
    Caption = 'lb'
  end
  object pb: TProgressBar
    Left = 8
    Top = 27
    Width = 325
    Height = 17
    TabOrder = 0
  end
  object bt: TButton
    Left = 258
    Top = 50
    Width = 75
    Height = 25
    Caption = 'bt'
    TabOrder = 1
    OnClick = btClick
  end
end
