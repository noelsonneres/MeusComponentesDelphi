object frxExprEditorForm: TfrxExprEditorForm
  Left = 200
  Top = 108
  Width = 640
  Height = 546
  ActiveControl = ExprMemo
  BorderIcons = [biSystemMenu, biMinimize, biMaximize, biHelp]
  Caption = 'Expression Editor'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = True
  ShowHint = True
  OnCreate = FormCreate
  OnHide = FormHide
  OnKeyDown = FormKeyDown
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 0
    Top = 412
    Width = 624
    Height = 3
    Cursor = crVSplit
    Align = alBottom
  end
  object ExprMemo: TMemo
    Left = 0
    Top = 415
    Width = 624
    Height = 56
    Align = alBottom
    BorderStyle = bsNone
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    WantReturns = False
    OnDragDrop = ExprMemoDragDrop
    OnDragOver = ExprMemoDragOver
  end
  object Panel1: TPanel
    Left = 0
    Top = 471
    Width = 624
    Height = 37
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object OkB: TButton
      Left = 4
      Top = 8
      Width = 75
      Height = 25
      Caption = 'OK'
      ModalResult = 1
      TabOrder = 0
    end
    object CancelB: TButton
      Left = 84
      Top = 8
      Width = 75
      Height = 25
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 393
    Width = 624
    Height = 19
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    object ExprL: TLabel
      Left = 4
      Top = 2
      Width = 56
      Height = 13
      Caption = 'Expression:'
    end
  end
  object Panel: TPanel
    Left = 0
    Top = 0
    Width = 624
    Height = 393
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 3
  end
end
