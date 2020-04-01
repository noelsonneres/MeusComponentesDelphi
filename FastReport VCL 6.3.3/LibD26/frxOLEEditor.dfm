object frxOleEditorForm: TfrxOleEditorForm
  Left = 200
  Top = 108
  BorderIcons = [biSystemMenu, biMinimize, biMaximize, biHelp]
  Caption = 'OLE object'
  ClientHeight = 270
  ClientWidth = 426
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
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object InsertB: TButton
    Left = 336
    Top = 8
    Width = 85
    Height = 25
    HelpContext = 52
    Anchors = [akTop, akRight]
    Caption = 'Insert...'
    TabOrder = 0
    OnClick = InsertBClick
  end
  object EditB: TButton
    Left = 336
    Top = 36
    Width = 85
    Height = 25
    HelpContext = 119
    Anchors = [akTop, akRight]
    Caption = 'Edit...'
    TabOrder = 1
    OnClick = EditBClick
  end
  object CloseB: TButton
    Left = 336
    Top = 64
    Width = 85
    Height = 25
    HelpContext = 40
    Anchors = [akTop, akRight]
    Caption = 'Close'
    ModalResult = 1
    TabOrder = 2
  end
  object OleContainer: TOleContainer
    Left = 4
    Top = 8
    Width = 325
    Height = 257
    HelpContext = 125
    AutoActivate = aaManual
    AutoVerbMenu = False
    Anchors = [akLeft, akTop, akRight, akBottom]
    Caption = 'OleContainer'
    SizeMode = smStretch
    TabOrder = 3
  end
end
