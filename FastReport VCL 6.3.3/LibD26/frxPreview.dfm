object frxPreviewForm: TfrxPreviewForm
  Left = 192
  Top = 125
  Width = 819
  Height = 622
  Caption = 'Preview'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  PopupMenu = RightMenu
  Position = poScreenCenter
  Scaled = False
  ShowHint = True
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  OnMouseWheel = FormMouseWheel
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object ToolBar: TToolBar
    Left = 0
    Top = 0
    Width = 803
    Height = 35
    AutoSize = True
    BorderWidth = 2
    ButtonHeight = 23
    TabOrder = 0
    Wrapable = False
    object PrintB: TToolButton
      Left = 0
      Top = 2
      Caption = 'Print'
      ImageIndex = 2
      OnClick = PrintBClick
    end
    object OpenB: TToolButton
      Left = 23
      Top = 2
      Caption = 'Open'
      ImageIndex = 0
      OnClick = OpenBClick
    end
    object SaveB: TToolButton
      Left = 46
      Top = 2
      Caption = 'Save'
      DropdownMenu = ExportPopup
      ImageIndex = 1
    end
    object PdfB: TToolButton
      Left = 69
      Top = 2
      Caption = 'PdfB'
      ImageIndex = 24
      Visible = False
      OnClick = PdfBClick
    end
    object EmailB: TToolButton
      Left = 92
      Top = 2
      Caption = 'EmailB'
      ImageIndex = 23
      Visible = False
      OnClick = EmailBClick
    end
    object FindB: TToolButton
      Left = 115
      Top = 2
      Caption = 'Find'
      ImageIndex = 4
      OnClick = FindBClick
    end
    object Sep1: TToolButton
      Left = 138
      Top = 2
      Width = 8
      ImageIndex = 7
      Style = tbsSeparator
    end
    object ZoomPlusB: TToolButton
      Left = 146
      Top = 2
      Caption = 'Zoom'
      ImageIndex = 15
      OnClick = ZoomPlusBClick
    end
    object Sep3: TfrxTBPanel
      Left = 169
      Top = 2
      Width = 56
      Height = 23
      Align = alLeft
      BevelOuter = bvNone
      ParentBackground = False
      TabOrder = 0
      object ZoomCB: TfrxComboBox
        Left = 4
        Top = 2
        Width = 49
        Height = 19
        ItemHeight = 13
        ListWidth = 100
        TabOrder = 0
        Text = '100%'
        ItemIndex = -1
        OnClick = ZoomCBClick
      end
    end
    object ZoomMinusB: TToolButton
      Left = 225
      Top = 2
      Caption = 'Whole Page'
      ImageIndex = 16
      OnClick = ZoomMinusBClick
    end
    object FullScreenBtn: TToolButton
      Left = 248
      Top = 2
      Caption = 'F'
      ImageIndex = 22
      OnClick = FullScreenBtnClick
    end
    object Sep2: TToolButton
      Left = 271
      Top = 2
      Width = 8
      ImageIndex = 6
      Style = tbsSeparator
    end
    object OutlineB: TToolButton
      Left = 279
      Top = 2
      AllowAllUp = True
      Grouped = True
      ImageIndex = 12
      Style = tbsCheck
      OnClick = OutlineBClick
    end
    object ThumbB: TToolButton
      Left = 302
      Top = 2
      AllowAllUp = True
      Caption = 'ThumbB'
      Grouped = True
      ImageIndex = 5
      Style = tbsCheck
      OnClick = ThumbBClick
    end
    object PageSettingsB: TToolButton
      Left = 325
      Top = 2
      Caption = 'Margins'
      ImageIndex = 7
      OnClick = PageSettingsBClick
    end
    object DesignerB: TToolButton
      Left = 348
      Top = 2
      Caption = 'Edit'
      ImageIndex = 21
      OnClick = DesignerBClick
      OnMouseUp = DesignerBMouseUp
    end
    object Sep5: TToolButton
      Left = 371
      Top = 2
      Width = 8
      ImageIndex = 11
      Style = tbsSeparator
    end
    object FirstB: TToolButton
      Left = 379
      Top = 2
      Caption = 'First'
      ImageIndex = 8
      OnClick = FirstBClick
    end
    object PriorB: TToolButton
      Left = 402
      Top = 2
      Caption = 'Prior'
      ImageIndex = 9
      OnClick = PriorBClick
    end
    object Sep4: TfrxTBPanel
      Left = 425
      Top = 2
      Width = 73
      Height = 23
      Align = alLeft
      BevelOuter = bvNone
      ParentBackground = False
      TabOrder = 1
      object OfNL: TLabel
        Left = 48
        Top = 4
        Width = 20
        Height = 13
        Caption = 'of N'
      end
      object PageE: TEdit
        Left = 4
        Top = 4
        Width = 37
        Height = 15
        BorderStyle = bsNone
        Ctl3D = True
        ParentCtl3D = False
        TabOrder = 0
        Text = '1'
      end
    end
    object NextB: TToolButton
      Left = 498
      Top = 2
      Caption = 'Next'
      ImageIndex = 10
      OnClick = NextBClick
    end
    object LastB: TToolButton
      Left = 521
      Top = 2
      Caption = 'Last'
      ImageIndex = 11
      OnClick = LastBClick
    end
    object HighlightEditableTB: TToolButton
      Left = 544
      Top = 2
      AllowAllUp = True
      Caption = 'HighlightEditableTB'
      ImageIndex = 25
      Style = tbsCheck
      OnClick = HighlightEditableTBClick
    end
    object frTBPanel1: TfrxTBPanel
      Left = 567
      Top = 2
      Width = 35
      Height = 23
      Align = alLeft
      BevelOuter = bvNone
      ParentBackground = False
      TabOrder = 2
    end
    object CancelB: TSpeedButton
      Left = 602
      Top = 2
      Width = 68
      Height = 23
      Caption = 'Close'
      Spacing = 2
      OnClick = CancelBClick
    end
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 565
    Width = 803
    Height = 19
    Panels = <
      item
        Text = 'Page 1 of 1000'
        Width = 200
      end
      item
        Width = 50
      end
      item
        Width = 50
      end>
  end
  object ExportPopup: TPopupMenu
    Left = 92
    Top = 84
  end
  object HiddenMenu: TPopupMenu
    Left = 228
    Top = 96
    object Showtemplate1: TMenuItem
      Caption = 'Show template'
      OnClick = Showtemplate1Click
    end
  end
  object RightMenu: TPopupMenu
    OnPopup = RightMenuPopup
    Left = 304
    Top = 92
    object CopyCmd1: TMenuItem
      Action = CopyCmd
    end
    object PasteCmd1: TMenuItem
      Action = PasteCmd
    end
    object CollapseMI: TMenuItem
      Caption = 'Collapse all'
      ImageIndex = 13
      OnClick = CollapseAllClick
    end
    object ExpandMI: TMenuItem
      Caption = 'Expand all'
      ImageIndex = 14
      OnClick = ExpandAllClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
  end
  object PreviewActionList: TActionList
    Left = 456
    Top = 104
    object CopyCmd: TAction
      Caption = 'CopyCmd'
      ImageIndex = 26
      ShortCut = 16451
      OnExecute = CopyCmdExecute
    end
    object PasteCmd: TAction
      Caption = 'PasteCmd'
      ImageIndex = 27
      ShortCut = 16470
      OnExecute = PasteCmdExecute
    end
  end
end
