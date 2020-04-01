object frxPictureEditorForm: TfrxPictureEditorForm
  Left = 200
  Top = 107
  BorderStyle = bsDialog
  Caption = 'Picture'
  ClientHeight = 307
  ClientWidth = 336
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = True
  Position = poScreenCenter
  ShowHint = True
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object ToolBar: TToolBar
    Left = 0
    Top = 0
    Width = 336
    Height = 31
    AutoSize = True
    BorderWidth = 2
    ButtonHeight = 23
    EdgeBorders = []
    Flat = True
    TabOrder = 0
    object LoadB: TToolButton
      Left = 0
      Top = 0
      Caption = 'Load'
      ImageIndex = 1
      OnClick = LoadBClick
    end
    object CopyB: TToolButton
      Left = 23
      Top = 0
      Caption = 'Copy'
      ImageIndex = 6
      OnClick = CopyBClick
    end
    object PasteB: TToolButton
      Left = 46
      Top = 0
      Caption = 'Paste'
      ImageIndex = 7
      OnClick = PasteBClick
    end
    object ClearB: TToolButton
      Left = 69
      Top = 0
      Caption = 'Clear'
      ImageIndex = 82
      OnClick = ClearBClick
    end
    object ToolButton1: TToolButton
      Left = 92
      Top = 0
      Width = 10
      ImageIndex = 3
      Style = tbsSeparator
    end
    object CancelB: TToolButton
      Left = 102
      Top = 0
      Caption = 'Cancel'
      ImageIndex = 55
      OnClick = CancelBClick
    end
    object OkB: TToolButton
      Left = 125
      Top = 0
      Caption = 'OK'
      ImageIndex = 56
      OnClick = OkBClick
    end
  end
  object Box: TScrollBox
    Left = 0
    Top = 31
    Width = 336
    Height = 257
    Align = alClient
    BorderStyle = bsNone
    Color = clWindow
    ParentColor = False
    TabOrder = 1
    object Image: TImage
      Left = 4
      Top = 4
      Width = 325
      Height = 241
      Center = True
    end
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 288
    Width = 336
    Height = 19
    Panels = <
      item
        Width = 50
      end>
    ParentFont = True
    UseSystemFont = False
  end
end
