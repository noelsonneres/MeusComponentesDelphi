object frxDesignerForm: TfrxDesignerForm
  Left = 418
  Top = 263
  Width = 1369
  Height = 787
  Caption = 'Designer'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  Menu = MainMenu
  OldCreateOrder = False
  ShowHint = True
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnMouseWheel = FormMouseWheel
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 0
    Top = 0
    Width = 1353
    Height = 1
    Align = alTop
    Style = bsRaised
    Visible = False
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 710
    Width = 1353
    Height = 19
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    Panels = <
      item
        Width = 75
      end
      item
        Style = psOwnerDraw
        Width = 230
      end
      item
        Width = 50
      end>
    UseSystemFont = False
    OnDblClick = StatusBarDblClick
    OnMouseDown = StatusBarMouseDown
    OnDrawPanel = StatusBarDrawPanel
  end
  object DockBottom: TControlBar
    Left = 0
    Top = 709
    Width = 1353
    Height = 1
    Align = alBottom
    AutoSize = True
    BevelKind = bkNone
    RowSize = 27
    TabOrder = 1
  end
  object DockTop: TControlBar
    Left = 0
    Top = 1
    Width = 1353
    Height = 54
    Align = alTop
    AutoSize = True
    BevelKind = bkNone
    RowSize = 27
    TabOrder = 3
    object TextTB: TToolBar
      Left = 11
      Top = 29
      Width = 639
      Height = 23
      Align = alNone
      AutoSize = True
      ButtonHeight = 23
      Caption = 'Text'
      DragKind = dkDock
      DragMode = dmAutomatic
      EdgeBorders = []
      Flat = True
      TabOrder = 1
      Wrapable = False
      object PanelTB1: TfrxTBPanel
        Left = 0
        Top = 0
        Width = 293
        Height = 23
        Align = alLeft
        BevelOuter = bvNone
        ParentBackground = False
        TabOrder = 0
        object FontSizeCB: TfrxComboBox
          Tag = 1
          Left = 248
          Top = 2
          Width = 40
          Height = 19
          ItemHeight = 13
          Items.Strings = (
            '5'
            '6'
            '7'
            '8'
            '9'
            '10'
            '11'
            '12'
            '14'
            '16'
            '18'
            '20'
            '22'
            '24'
            '26'
            '28'
            '36'
            '48'
            '72')
          ListWidth = 0
          TabOrder = 0
          ItemIndex = -1
          OnClick = ToolButtonClick
        end
        object FontNameCB: TfrxFontComboBox
          Left = 98
          Top = 2
          Width = 145
          Height = 19
          MRURegKey = '\Software\Fast Reports\MRUFont'
          DropDownCount = 12
          ItemHeight = 13
          TabOrder = 1
          OnClick = ToolButtonClick
        end
        object StyleCB: TfrxComboBox
          Tag = 33
          Left = 0
          Top = 2
          Width = 93
          Height = 19
          ItemHeight = 13
          ListWidth = 120
          TabOrder = 2
          ItemIndex = -1
          OnClick = ToolButtonClick
        end
      end
      object BoldB: TToolButton
        Tag = 2
        Left = 293
        Top = 0
        AllowAllUp = True
        ImageIndex = 20
        Style = tbsCheck
        OnClick = ToolButtonClick
      end
      object ItalicB: TToolButton
        Tag = 3
        Left = 316
        Top = 0
        AllowAllUp = True
        ImageIndex = 21
        Style = tbsCheck
        OnClick = ToolButtonClick
      end
      object UnderlineB: TToolButton
        Tag = 4
        Left = 339
        Top = 0
        AllowAllUp = True
        ImageIndex = 22
        Style = tbsCheck
        OnClick = ToolButtonClick
      end
      object SepTB8: TToolButton
        Left = 362
        Top = 0
        Width = 8
        ImageIndex = 0
        Style = tbsSeparator
      end
      object FontB: TToolButton
        Tag = 43
        Left = 370
        Top = 0
        ImageIndex = 59
      end
      object FontColorB: TToolButton
        Tag = 5
        Left = 393
        Top = 0
        DropdownMenu = FontColorPopupMenu
        ImageIndex = 23
        Style = tbsDropDown
        OnClick = FontColorBClick
      end
      object HighlightB: TToolButton
        Tag = 6
        Left = 431
        Top = 0
        ImageIndex = 24
        OnClick = HighlightBClick
      end
      object RotateB: TToolButton
        Left = 454
        Top = 0
        DropdownMenu = RotationPopup
        ImageIndex = 64
      end
      object SepTB9: TToolButton
        Left = 477
        Top = 0
        Width = 8
        ImageIndex = 0
        Style = tbsSeparator
      end
      object TextAlignLeftB: TToolButton
        Tag = 7
        Left = 485
        Top = 0
        Grouped = True
        ImageIndex = 25
        Style = tbsCheck
        OnClick = ToolButtonClick
      end
      object TextAlignCenterB: TToolButton
        Tag = 8
        Left = 508
        Top = 0
        Grouped = True
        ImageIndex = 26
        Style = tbsCheck
        OnClick = ToolButtonClick
      end
      object TextAlignRightB: TToolButton
        Tag = 9
        Left = 531
        Top = 0
        Grouped = True
        ImageIndex = 27
        Style = tbsCheck
        OnClick = ToolButtonClick
      end
      object TextAlignBlockB: TToolButton
        Tag = 10
        Left = 554
        Top = 0
        Grouped = True
        ImageIndex = 28
        Style = tbsCheck
        OnClick = ToolButtonClick
      end
      object SepTB10: TToolButton
        Left = 577
        Top = 0
        Width = 8
        ImageIndex = 0
        Style = tbsSeparator
      end
      object TextAlignTopB: TToolButton
        Tag = 11
        Left = 585
        Top = 0
        Grouped = True
        ImageIndex = 29
        Style = tbsCheck
        OnClick = ToolButtonClick
      end
      object TextAlignMiddleB: TToolButton
        Tag = 12
        Left = 608
        Top = 0
        Grouped = True
        ImageIndex = 30
        Style = tbsCheck
        OnClick = ToolButtonClick
      end
      object TextAlignBottomB: TToolButton
        Tag = 13
        Left = 631
        Top = 0
        Grouped = True
        ImageIndex = 31
        Style = tbsCheck
        OnClick = ToolButtonClick
      end
    end
    object FrameTB: TToolBar
      Left = 678
      Top = 29
      Width = 316
      Height = 23
      Align = alNone
      AutoSize = True
      ButtonHeight = 23
      Caption = 'Frame'
      DragKind = dkDock
      DragMode = dmAutomatic
      EdgeBorders = []
      Flat = True
      TabOrder = 2
      Wrapable = False
      object FrameTopB: TToolButton
        Tag = 20
        Left = 0
        Top = 0
        AllowAllUp = True
        ImageIndex = 32
        Style = tbsCheck
        OnClick = ToolButtonClick
      end
      object FrameBottomB: TToolButton
        Tag = 21
        Left = 23
        Top = 0
        AllowAllUp = True
        ImageIndex = 33
        Style = tbsCheck
        OnClick = ToolButtonClick
      end
      object FrameLeftB: TToolButton
        Tag = 22
        Left = 46
        Top = 0
        AllowAllUp = True
        ImageIndex = 34
        Style = tbsCheck
        OnClick = ToolButtonClick
      end
      object FrameRightB: TToolButton
        Tag = 23
        Left = 69
        Top = 0
        AllowAllUp = True
        ImageIndex = 35
        Style = tbsCheck
        OnClick = ToolButtonClick
      end
      object SepTB11: TToolButton
        Left = 92
        Top = 0
        Width = 8
        ImageIndex = 0
        Style = tbsSeparator
      end
      object FrameAllB: TToolButton
        Tag = 24
        Left = 100
        Top = 0
        ImageIndex = 36
        OnClick = ToolButtonClick
      end
      object FrameNoB: TToolButton
        Tag = 25
        Left = 123
        Top = 0
        ImageIndex = 37
        OnClick = ToolButtonClick
      end
      object FrameEditB: TToolButton
        Tag = 32
        Left = 146
        Top = 0
        ImageIndex = 60
        OnClick = ToolButtonClick
      end
      object SepTB12: TToolButton
        Left = 169
        Top = 0
        Width = 8
        ImageIndex = 0
        Style = tbsSeparator
      end
      object FillColorB: TToolButton
        Tag = 26
        Left = 177
        Top = 0
        DropdownMenu = FillColorPopupMenu
        ImageIndex = 38
        Style = tbsDropDown
        OnClick = FillColorBClick
      end
      object FillEditB: TToolButton
        Tag = 44
        Left = 215
        Top = 0
        ImageIndex = 109
        OnClick = ToolButtonClick
      end
      object FrameColorB: TToolButton
        Tag = 27
        Left = 238
        Top = 0
        DropdownMenu = FrameColorPopupMenu
        ImageIndex = 39
        Style = tbsDropDown
        OnClick = FrameColorBClick
      end
      object FrameStyleB: TToolButton
        Tag = 28
        Left = 276
        Top = 0
        ImageIndex = 40
        OnClick = FrameStyleBClick
      end
      object PanelTB2: TfrxTBPanel
        Left = 299
        Top = 0
        Width = 47
        Height = 23
        Align = alLeft
        BevelOuter = bvNone
        ParentBackground = False
        TabOrder = 0
        object FrameWidthCB: TfrxComboBox
          Tag = 29
          Left = 5
          Top = 2
          Width = 40
          Height = 19
          ItemHeight = 13
          Items.Strings = (
            '0,1'
            '0,5'
            '1'
            '1,5'
            '2'
            '3'
            '4'
            '5'
            '6'
            '7'
            '8'
            '9'
            '10')
          ListWidth = 0
          TabOrder = 0
          ItemIndex = -1
          OnClick = ToolButtonClick
        end
      end
    end
    object StandardTB: TToolBar
      Left = 11
      Top = 2
      Width = 441
      Height = 23
      Align = alNone
      AutoSize = True
      ButtonHeight = 23
      Caption = 'Standard'
      DragKind = dkDock
      DragMode = dmAutomatic
      EdgeBorders = []
      Flat = True
      TabOrder = 3
      Wrapable = False
      object NewB: TToolButton
        Tag = 40
        Left = 0
        Top = 0
        Action = NewReportCmd
      end
      object OpenB: TToolButton
        Tag = 41
        Left = 23
        Top = 0
        Action = OpenCmd
      end
      object SaveB: TToolButton
        Tag = 42
        Left = 46
        Top = 0
        Action = SaveCmd
      end
      object PreviewB: TToolButton
        Tag = 43
        Left = 69
        Top = 0
        Action = PreviewCmd
      end
      object SepTB4: TToolButton
        Left = 92
        Top = 0
        Width = 8
        ImageIndex = 0
        Style = tbsSeparator
      end
      object NewPageB: TToolButton
        Tag = 52
        Left = 100
        Top = 0
        Action = NewPageCmd
      end
      object NewDialogB: TToolButton
        Tag = 70
        Left = 123
        Top = 0
        Action = NewDialogCmd
      end
      object DeletePageB: TToolButton
        Tag = 53
        Left = 146
        Top = 0
        Action = DeletePageCmd
      end
      object PageSettingsB: TToolButton
        Tag = 54
        Left = 169
        Top = 0
        Action = PageSettingsCmd
      end
      object SepTB13: TToolButton
        Left = 192
        Top = 0
        Width = 8
        ImageIndex = 21
        Style = tbsSeparator
      end
      object CutB: TToolButton
        Tag = 44
        Left = 200
        Top = 0
        Action = CutCmd
      end
      object CopyB: TToolButton
        Tag = 45
        Left = 223
        Top = 0
        Action = CopyCmd
      end
      object PasteB: TToolButton
        Tag = 46
        Left = 246
        Top = 0
        Action = PasteCmd
      end
      object SepTB2: TToolButton
        Left = 269
        Top = 0
        Width = 8
        ImageIndex = 0
        Style = tbsSeparator
      end
      object UndoB: TToolButton
        Tag = 47
        Left = 277
        Top = 0
        Action = UndoCmd
      end
      object RedoB: TToolButton
        Tag = 48
        Left = 300
        Top = 0
        Action = RedoCmd
      end
      object SepTB3: TToolButton
        Left = 323
        Top = 0
        Width = 8
        ImageIndex = 0
        Style = tbsSeparator
      end
      object GroupB: TToolButton
        Left = 331
        Top = 0
        Action = GroupCmd
        ImageIndex = 17
      end
      object UngroupB: TToolButton
        Left = 354
        Top = 0
        Action = UngroupCmd
      end
      object SepTB20: TToolButton
        Left = 377
        Top = 0
        Width = 8
        ImageIndex = 60
        Style = tbsSeparator
      end
      object PanelTB3: TfrxTBPanel
        Left = 385
        Top = 0
        Width = 56
        Height = 23
        Align = alLeft
        BevelOuter = bvNone
        ParentBackground = False
        TabOrder = 0
        object ScaleCB: TfrxComboBox
          Left = 0
          Top = 2
          Width = 52
          Height = 19
          Hint = 'Scale'
          ItemHeight = 13
          Items.Strings = (
            '25%'
            '50%'
            '75%'
            '100%'
            '150%'
            '200%'
            'Page width'
            'Whole page')
          ListWidth = 100
          TabOrder = 0
          Text = '100%'
          ItemIndex = -1
          OnClick = ScaleCBClick
        end
      end
    end
    object ExtraToolsTB: TToolBar
      Left = 901
      Top = 2
      Width = 19
      Height = 23
      Align = alNone
      AutoSize = True
      ButtonHeight = 23
      Caption = 'Extra Tools'
      DragKind = dkDock
      DragMode = dmAutomatic
      EdgeBorders = []
      Flat = True
      TabOrder = 4
      Wrapable = False
    end
    object AlignTB: TToolBar
      Left = 465
      Top = 2
      Width = 385
      Height = 23
      Align = alNone
      AutoSize = True
      ButtonHeight = 23
      Caption = 'Align'
      DragKind = dkDock
      DragMode = dmAutomatic
      EdgeBorders = []
      Flat = True
      TabOrder = 0
      Wrapable = False
      object ShowGridB: TToolButton
        Tag = 55
        Left = 0
        Top = 0
        AllowAllUp = True
        ImageIndex = 18
        Style = tbsCheck
        OnClick = ShowGridBClick
      end
      object AlignToGridB: TToolButton
        Tag = 56
        Left = 23
        Top = 0
        AllowAllUp = True
        ImageIndex = 19
        Style = tbsCheck
        OnClick = AlignToGridBClick
      end
      object SetToGridB: TToolButton
        Tag = 31
        Left = 46
        Top = 0
        ImageIndex = 57
        OnClick = ToolButtonClick
      end
      object ToolButton1: TToolButton
        Left = 69
        Top = 0
        Width = 8
        Caption = 'ToolButton1'
        ImageIndex = 85
        Style = tbsSeparator
      end
      object AlignLeftsB: TToolButton
        Tag = 60
        Left = 77
        Top = 0
        Caption = 'AlignLeftsB'
        ImageIndex = 41
        OnClick = AlignLeftsBClick
      end
      object AlignHorzCentersB: TToolButton
        Tag = 60
        Left = 100
        Top = 0
        Caption = 'AlignHorzCentersB'
        ImageIndex = 42
        OnClick = AlignHorzCentersBClick
      end
      object AlignRightsB: TToolButton
        Tag = 60
        Left = 123
        Top = 0
        Caption = 'AlignRightsB'
        ImageIndex = 45
        OnClick = AlignRightsBClick
      end
      object SepTB15: TToolButton
        Left = 146
        Top = 0
        Width = 8
        ImageIndex = 85
        Style = tbsSeparator
      end
      object AlignTopsB: TToolButton
        Tag = 60
        Left = 154
        Top = 0
        Caption = 'AlignTopsB'
        ImageIndex = 46
        OnClick = AlignTopsBClick
      end
      object AlignVertCentersB: TToolButton
        Tag = 60
        Left = 177
        Top = 0
        Caption = 'AlignVertCentersB'
        ImageIndex = 47
        OnClick = AlignVertCentersBClick
      end
      object AlignBottomsB: TToolButton
        Tag = 60
        Left = 200
        Top = 0
        Caption = 'AlignBottomsB'
        ImageIndex = 50
        OnClick = AlignBottomsBClick
      end
      object SepTB16: TToolButton
        Left = 223
        Top = 0
        Width = 8
        ImageIndex = 85
        Style = tbsSeparator
      end
      object SpaceHorzB: TToolButton
        Tag = 60
        Left = 231
        Top = 0
        Caption = 'SpaceHorzB'
        ImageIndex = 44
        OnClick = SpaceHorzBClick
      end
      object SpaceVertB: TToolButton
        Tag = 60
        Left = 254
        Top = 0
        Caption = 'SpaceVertB'
        ImageIndex = 49
        OnClick = SpaceVertBClick
      end
      object SepTB17: TToolButton
        Left = 277
        Top = 0
        Width = 8
        ImageIndex = 86
        Style = tbsSeparator
      end
      object CenterHorzB: TToolButton
        Tag = 60
        Left = 285
        Top = 0
        Caption = 'CenterHorzB'
        ImageIndex = 43
        OnClick = CenterHorzBClick
      end
      object CenterVertB: TToolButton
        Tag = 60
        Left = 308
        Top = 0
        Caption = 'CenterVertB'
        ImageIndex = 48
        OnClick = CenterVertBClick
      end
      object SepTB18: TToolButton
        Left = 331
        Top = 0
        Width = 8
        ImageIndex = 85
        Style = tbsSeparator
      end
      object SameWidthB: TToolButton
        Left = 339
        Top = 0
        Caption = 'SameWidthB'
        ImageIndex = 83
        OnClick = SameWidthBClick
      end
      object SameHeightB: TToolButton
        Left = 362
        Top = 0
        Caption = 'SameHeightB'
        ImageIndex = 84
        OnClick = SameHeightBClick
      end
    end
  end
  object LeftDockSite1: TfrxDockSite
    Left = 0
    Top = 55
    Width = 17
    Height = 654
    Align = alLeft
    AutoSize = True
    BevelOuter = bvNone
    Caption = ' '
    DockSite = True
    TabOrder = 2
    OnDockOver = CodeDockSiteDockOver
  end
  object ObjectsTB1: TToolBar
    Left = 23
    Top = 55
    Width = 27
    Height = 654
    Align = alLeft
    BorderWidth = 1
    ButtonHeight = 23
    TabOrder = 4
    Wrapable = False
  end
  object BackPanel: TPanel
    Left = 50
    Top = 55
    Width = 1303
    Height = 654
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 5
    object ScrollBoxPanel: TPanel
      Left = 65
      Top = 95
      Width = 297
      Height = 297
      BevelOuter = bvNone
      TabOrder = 0
      object ScrollBox: TfrxScrollBox
        Left = 21
        Top = 22
        Width = 276
        Height = 275
        HorzScrollBar.Margin = 10
        HorzScrollBar.Tracking = True
        VertScrollBar.Margin = 10
        VertScrollBar.Tracking = True
        Align = alClient
        BorderStyle = bsNone
        Color = clGray
        ParentColor = False
        TabOrder = 0
        OnMouseWheelDown = ScrollBoxMouseWheelDown
        OnMouseWheelUp = ScrollBoxMouseWheelUp
        OnResize = ScrollBoxResize
      end
      object LeftRuler: TfrxRuler
        Left = 0
        Top = 22
        Width = 21
        Height = 275
        Cursor = crHandPoint
        Align = alLeft
        DragCursor = crHSplit
        DragMode = dmAutomatic
        TabOrder = 1
        OnDragOver = TopRulerDragOver
        Offset = 0
        Scale = 1.000000000000000000
        Start = 0
        Units = ruCM
        Size = 0
      end
      object TopRuler: TfrxRuler
        Left = 0
        Top = 0
        Width = 297
        Height = 22
        Cursor = crHandPoint
        Align = alTop
        DragCursor = crVSplit
        DragMode = dmAutomatic
        TabOrder = 2
        OnDragOver = TopRulerDragOver
        Offset = 22
        Scale = 1.000000000000000000
        Start = 0
        Units = ruCM
        Size = 0
      end
    end
    object CodePanel: TPanel
      Left = 394
      Top = 98
      Width = 377
      Height = 289
      BevelOuter = bvNone
      TabOrder = 1
      object CodeTB: TToolBar
        Left = 0
        Top = 0
        Width = 377
        Height = 25
        ButtonHeight = 23
        TabOrder = 0
        object frTBPanel1: TfrxTBPanel
          Left = 0
          Top = 2
          Width = 169
          Height = 23
          Align = alLeft
          BevelOuter = bvNone
          ParentBackground = False
          TabOrder = 0
          object LangL: TLabel
            Left = 4
            Top = 4
            Width = 51
            Height = 13
            Caption = 'Language:'
          end
          object LangCB: TfrxComboBox
            Left = 60
            Top = 2
            Width = 100
            Height = 19
            ItemHeight = 13
            ListWidth = 0
            TabOrder = 0
            ItemIndex = -1
            OnClick = LangCBClick
          end
        end
        object OpenScriptB: TToolButton
          Left = 169
          Top = 2
          ImageIndex = 1
          OnClick = OpenScriptBClick
        end
        object SaveScriptB: TToolButton
          Left = 192
          Top = 2
          ImageIndex = 2
          OnClick = SaveScriptBClick
        end
        object SepTB19: TToolButton
          Left = 215
          Top = 2
          Width = 8
          ImageIndex = 73
          Style = tbsSeparator
        end
        object RunScriptB: TToolButton
          Left = 223
          Top = 2
          ImageIndex = 90
          OnClick = RunScriptBClick
        end
        object RunToCursorB: TToolButton
          Left = 246
          Top = 2
          ImageIndex = 95
          OnClick = RunToCursorBClick
        end
        object StepScriptB: TToolButton
          Left = 269
          Top = 2
          ImageIndex = 91
          OnClick = RunScriptBClick
        end
        object StopScriptB: TToolButton
          Left = 292
          Top = 2
          ImageIndex = 93
          OnClick = StopScriptBClick
        end
        object EvaluateB: TToolButton
          Left = 315
          Top = 2
          ImageIndex = 92
          OnClick = EvaluateBClick
        end
        object BreakPointB: TToolButton
          Left = 338
          Top = 2
          ImageIndex = 94
          OnClick = BreakPointBClick
        end
      end
      object CodeDockSite: TfrxDockSite
        Left = 0
        Top = 279
        Width = 377
        Height = 10
        Align = alBottom
        AutoSize = True
        BevelOuter = bvNone
        Caption = ' '
        Constraints.MaxHeight = 268
        DockSite = True
        TabOrder = 1
        OnDockOver = CodeDockSiteDockOver
      end
    end
    object LeftDockSite2: TfrxDockSite
      Left = 0
      Top = 2
      Width = 9
      Height = 652
      Align = alLeft
      AutoSize = True
      BevelOuter = bvNone
      Caption = ' '
      DockSite = True
      TabOrder = 2
      OnDockOver = CodeDockSiteDockOver
    end
    object RightDockSite: TfrxDockSite
      Left = 1295
      Top = 2
      Width = 8
      Height = 652
      Align = alRight
      AutoSize = True
      BevelOuter = bvNone
      Caption = ' '
      DockSite = True
      TabOrder = 3
      OnDockOver = CodeDockSiteDockOver
    end
    object TabPanel: TPanel
      Left = 0
      Top = 0
      Width = 1303
      Height = 2
      Align = alTop
      AutoSize = True
      BevelOuter = bvNone
      TabOrder = 4
      object Panel1: TPanel
        Left = 84
        Top = 0
        Width = 65
        Height = 2
        BevelOuter = bvNone
        TabOrder = 0
      end
    end
  end
  object PagePopup: TPopupMenu
    AutoPopup = False
    OnPopup = PagePopupPopup
    Left = 216
    Top = 284
    object EditMI1: TMenuItem
      Action = EditCmd
    end
    object AddChildMI: TMenuItem
      Caption = 'Add child band'
      OnClick = AddChildMIClick
    end
    object SepMI12: TMenuItem
      Caption = '-'
    end
    object SepMI8: TMenuItem
      Caption = '-'
    end
    object CutMI1: TMenuItem
      Action = CutCmd
    end
    object CopyMI1: TMenuItem
      Action = CopyCmd
    end
    object CopyContent2: TMenuItem
      Action = CopyContentCmd
    end
    object PasteMI1: TMenuItem
      Action = PasteCmd
    end
    object DeleteMI1: TMenuItem
      Action = DeleteCmd
    end
    object SelectAllMI1: TMenuItem
      Action = SelectAllCmd
    end
    object SelectAllOfTypeMI: TMenuItem
      Action = SelectAllOfTypeCmd
      Caption = 'Select same type on Parent'
    end
    object SelectAllOfTypeOnPageMI: TMenuItem
      Caption = 'Select same type on Page'
      OnClick = SelectAllOfTypeCmdExecute
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object BringtoFrontMI1: TMenuItem
      Action = BringToFrontCmd
    end
    object SendtoBackMI1: TMenuItem
      Action = SendToBackCmd
    end
    object TabOrderMI: TMenuItem
      Caption = 'Tab Order...'
      OnClick = TabOrderMIClick
    end
    object RevertInheritedMI: TMenuItem
      Caption = 'Reset to Parent object'
      OnClick = RevertInheritedMIClick
    end
    object RevertInheritedChildMI: TMenuItem
      Caption = 'Reset to Parent object with childs'
      OnClick = RevertInheritedMIClick
    end
  end
  object MainMenu: TMainMenu
    Left = 156
    Top = 316
    object FileMenu: TMenuItem
      Caption = '&File'
      object NewMI: TMenuItem
        Action = NewItemCmd
      end
      object NewReportMI: TMenuItem
        Action = NewReportCmd
      end
      object NewPageMI: TMenuItem
        Action = NewPageCmd
      end
      object NewDialogMI: TMenuItem
        Action = NewDialogCmd
      end
      object SepMI1: TMenuItem
        Caption = '-'
      end
      object OpenMI: TMenuItem
        Action = OpenCmd
      end
      object SaveMI: TMenuItem
        Action = SaveCmd
      end
      object SaveAsMI: TMenuItem
        Action = SaveAsCmd
      end
      object SepMI3: TMenuItem
        Caption = '-'
      end
      object PreviewMI: TMenuItem
        Action = PreviewCmd
      end
      object PageSettingsMI: TMenuItem
        Action = PageSettingsCmd
      end
      object SepMI11: TMenuItem
        Caption = '-'
        Visible = False
      end
      object SepMI4: TMenuItem
        Caption = '-'
      end
      object ExitMI: TMenuItem
        Action = ExitCmd
      end
    end
    object EditMenu: TMenuItem
      Caption = '&Edit'
      object UndoMI: TMenuItem
        Action = UndoCmd
      end
      object RedoMI: TMenuItem
        Action = RedoCmd
      end
      object SepMI5: TMenuItem
        Caption = '-'
      end
      object CutMI: TMenuItem
        Action = CutCmd
      end
      object CopyMI: TMenuItem
        Action = CopyCmd
      end
      object CopyContent1: TMenuItem
        Action = CopyContentCmd
      end
      object PasteMI: TMenuItem
        Action = PasteCmd
      end
      object DeleteMI: TMenuItem
        Action = DeleteCmd
      end
      object DeletePageMI: TMenuItem
        Action = DeletePageCmd
      end
      object SelectAllMI: TMenuItem
        Action = SelectAllCmd
      end
      object GroupMI: TMenuItem
        Action = GroupCmd
        ImageIndex = 17
      end
      object UngroupMI: TMenuItem
        Action = UngroupCmd
      end
      object EditMI: TMenuItem
        Action = EditCmd
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object FindMI: TMenuItem
        Action = FindCmd
      end
      object ReplaceMI: TMenuItem
        Action = ReplaceCmd
      end
      object FindNextMI: TMenuItem
        Action = FindNextCmd
      end
      object SepMI6: TMenuItem
        Caption = '-'
      end
      object BringtoFrontMI: TMenuItem
        Action = BringToFrontCmd
      end
      object SendtoBackMI: TMenuItem
        Action = SendToBackCmd
      end
    end
    object ReportMenu: TMenuItem
      Caption = '&Report'
      object ReportDataMI: TMenuItem
        Action = ReportDataCmd
      end
      object VariablesMI: TMenuItem
        Action = VariablesCmd
      end
      object ReportStylesMI: TMenuItem
        Action = ReportStylesCmd
      end
      object ReportSettingsMI: TMenuItem
        Action = ReportOptionsCmd
      end
    end
    object ViewMenu: TMenuItem
      Caption = '&View'
      object ToolbarsMI: TMenuItem
        Action = ToolbarsCmd
        object StandardMI: TMenuItem
          Action = StandardTBCmd
          GroupIndex = 1
        end
        object TextMI: TMenuItem
          Tag = 1
          Action = TextTBCmd
          GroupIndex = 1
        end
        object FrameMI: TMenuItem
          Tag = 2
          Action = FrameTBCmd
          GroupIndex = 1
        end
        object AlignmentMI: TMenuItem
          Tag = 3
          Action = AlignTBCmd
          GroupIndex = 1
        end
        object ToolsMI: TMenuItem
          Tag = 4
          Action = ExtraTBCmd
          GroupIndex = 1
        end
        object InspectorMI: TMenuItem
          Tag = 5
          Action = InspectorTBCmd
          GroupIndex = 1
        end
        object DataTreeMI: TMenuItem
          Tag = 6
          Action = DataTreeTBCmd
          GroupIndex = 1
        end
        object ReportTreeMI: TMenuItem
          Tag = 7
          Action = ReportTreeTBCmd
          GroupIndex = 1
        end
      end
      object SepMI9: TMenuItem
        Caption = '-'
      end
      object ShowRulersMI: TMenuItem
        Action = ShowRulersCmd
      end
      object ShowGuidesMI: TMenuItem
        Action = ShowGuidesCmd
      end
      object DeleteGuidesMI: TMenuItem
        Action = DeleteGuidesCmd
      end
      object SepMI10: TMenuItem
        Caption = '-'
      end
      object OptionsMI: TMenuItem
        Action = OptionsCmd
      end
      object ConnectionsMI: TMenuItem
        Caption = 'Connections...'
        OnClick = ConnectionsMIClick
      end
      object EdConfigMI: TMenuItem
        Action = EdConfigCmd
      end
    end
    object HelpMenu: TMenuItem
      Caption = '&Help'
      object HelpContentsMI: TMenuItem
        Action = HelpContentsCmd
      end
      object SepMI7: TMenuItem
        Caption = '-'
      end
      object AboutMI: TMenuItem
        Action = AboutCmd
      end
    end
  end
  object OpenDialog: TOpenDialog
    Left = 350
    Top = 316
  end
  object TabPopup: TPopupMenu
    Left = 216
    Top = 316
    object NewPageMI1: TMenuItem
      Action = NewPageCmd
    end
    object NewDialogMI1: TMenuItem
      Action = NewDialogCmd
    end
    object DeletePageMI1: TMenuItem
      Action = DeletePageCmd
    end
    object PageSettingsMI1: TMenuItem
      Action = PageSettingsCmd
    end
  end
  object ActionList: TActionList
    Left = 154
    Top = 284
    object UndoCmd: TAction
      Category = 'Edit'
      Caption = 'Undo'
      ImageIndex = 8
      ShortCut = 16474
      OnExecute = UndoCmdExecute
    end
    object RedoCmd: TAction
      Category = 'Edit'
      Caption = 'Redo'
      ImageIndex = 9
      OnExecute = RedoCmdExecute
    end
    object CutCmd: TAction
      Category = 'Edit'
      Caption = 'Cut'
      ImageIndex = 5
      ShortCut = 16472
      OnExecute = CutCmdExecute
    end
    object CopyCmd: TAction
      Category = 'Edit'
      Caption = 'Copy'
      ImageIndex = 6
      ShortCut = 16451
      OnExecute = CopyCmdExecute
    end
    object CopyContentCmd: TAction
      Category = 'Edit'
      Caption = 'Copy Content'
      ImageIndex = 6
      ShortCut = 49219
      OnExecute = CopyContentCmdExecute
    end
    object PasteCmd: TAction
      Category = 'Edit'
      Caption = 'Paste'
      Enabled = False
      ImageIndex = 7
      ShortCut = 16470
      OnExecute = PasteCmdExecute
    end
    object DeleteCmd: TAction
      Category = 'Edit'
      Caption = 'Delete'
      ImageIndex = 51
      OnExecute = DeleteCmdExecute
    end
    object DeletePageCmd: TAction
      Category = 'Edit'
      Caption = 'Delete Page'
      ImageIndex = 12
      OnExecute = DeletePageCmdExecute
    end
    object SelectAllCmd: TAction
      Category = 'Edit'
      Caption = 'Select All'
      ShortCut = 16449
      OnExecute = SelectAllCmdExecute
    end
    object EditCmd: TAction
      Category = 'Edit'
      Caption = 'Edit...'
      OnExecute = EditCmdExecute
    end
    object BringToFrontCmd: TAction
      Category = 'Edit'
      Caption = 'Bring to Front'
      ImageIndex = 14
      OnExecute = BringToFrontCmdExecute
    end
    object SendToBackCmd: TAction
      Category = 'Edit'
      Caption = 'Send to Back'
      ImageIndex = 15
      OnExecute = SendToBackCmdExecute
    end
    object NewItemCmd: TAction
      Category = 'File'
      Caption = 'New...'
      OnExecute = NewItemCmdExecute
    end
    object NewReportCmd: TAction
      Category = 'File'
      Caption = 'New Report'
      ImageIndex = 0
      OnExecute = NewReportCmdExecute
    end
    object NewPageCmd: TAction
      Category = 'File'
      Caption = 'New Page'
      ImageIndex = 10
      OnExecute = NewPageCmdExecute
    end
    object NewDialogCmd: TAction
      Category = 'File'
      Caption = 'New Dialog'
      ImageIndex = 11
      OnExecute = NewDialogCmdExecute
    end
    object OpenCmd: TAction
      Category = 'File'
      Caption = 'Open...'
      ImageIndex = 1
      ShortCut = 16463
      OnExecute = OpenCmdExecute
    end
    object SaveCmd: TAction
      Category = 'File'
      Caption = 'Save'
      ImageIndex = 2
      ShortCut = 16467
      OnExecute = SaveCmdExecute
    end
    object SaveAsCmd: TAction
      Category = 'File'
      Caption = 'Save As...'
      OnExecute = SaveAsCmdExecute
    end
    object PageSettingsCmd: TAction
      Category = 'File'
      Caption = 'Page Settings...'
      ImageIndex = 13
      OnExecute = PageSettingsCmdExecute
    end
    object PreviewCmd: TAction
      Category = 'File'
      Caption = 'Preview'
      ImageIndex = 3
      ShortCut = 16464
      OnExecute = PreviewCmdExecute
    end
    object ExitCmd: TAction
      Category = 'File'
      Caption = 'Exit'
      ShortCut = 32856
      OnExecute = ExitCmdExecute
    end
    object GroupCmd: TAction
      Category = 'Edit'
      Caption = 'Group'
      ImageIndex = 94
      OnExecute = GroupCmdExecute
    end
    object UngroupCmd: TAction
      Category = 'Edit'
      Caption = 'Ungroup'
      ImageIndex = 16
      OnExecute = UngroupCmdExecute
    end
    object FindCmd: TAction
      Category = 'Edit'
      Caption = 'Find...'
      ShortCut = 16454
      OnExecute = FindCmdExecute
    end
    object ReplaceCmd: TAction
      Category = 'Edit'
      Caption = 'Replace...'
      ShortCut = 16466
      OnExecute = ReplaceCmdExecute
    end
    object FindNextCmd: TAction
      Category = 'Edit'
      Caption = 'Find Next'
      Enabled = False
      ShortCut = 114
      OnExecute = FindNextCmdExecute
    end
    object ReportDataCmd: TAction
      Category = 'Report'
      Caption = 'Data...'
      ImageIndex = 53
      OnExecute = ReportDataCmdExecute
    end
    object VariablesCmd: TAction
      Category = 'Report'
      Caption = 'Variables...'
      ImageIndex = 52
      OnExecute = VariablesCmdExecute
    end
    object ReportStylesCmd: TAction
      Category = 'Report'
      Caption = 'Styles...'
      ImageIndex = 87
      OnExecute = ReportStylesCmdExecute
    end
    object ReportOptionsCmd: TAction
      Category = 'Report'
      Caption = 'Options...'
      OnExecute = ReportOptionsCmdExecute
    end
    object ShowRulersCmd: TAction
      Category = 'View'
      Caption = 'Rulers'
      OnExecute = ShowRulersCmdExecute
    end
    object ShowGuidesCmd: TAction
      Category = 'View'
      Caption = 'Guides'
      OnExecute = ShowGuidesCmdExecute
    end
    object DeleteGuidesCmd: TAction
      Category = 'View'
      Caption = 'Delete Guides'
      OnExecute = DeleteGuidesCmdExecute
    end
    object OptionsCmd: TAction
      Category = 'View'
      Caption = 'Options...'
      OnExecute = OptionsCmdExecute
    end
    object HelpContentsCmd: TAction
      Category = 'Help'
      Caption = 'Help Contents...'
      ShortCut = 112
      OnExecute = HelpContentsCmdExecute
    end
    object AboutCmd: TAction
      Category = 'Help'
      Caption = 'About FastReport...'
      OnExecute = AboutCmdExecute
    end
    object StandardTBCmd: TAction
      Category = 'Toolbars'
      Caption = 'Standard'
      OnExecute = StandardTBCmdExecute
    end
    object TextTBCmd: TAction
      Category = 'Toolbars'
      Caption = 'Text'
      OnExecute = TextTBCmdExecute
    end
    object FrameTBCmd: TAction
      Category = 'Toolbars'
      Caption = 'Frame'
      OnExecute = FrameTBCmdExecute
    end
    object AlignTBCmd: TAction
      Category = 'Toolbars'
      Caption = 'Alignment Palette'
      OnExecute = AlignTBCmdExecute
    end
    object ExtraTBCmd: TAction
      Category = 'Toolbars'
      Caption = 'Extra Tools'
      OnExecute = ExtraTBCmdExecute
    end
    object InspectorTBCmd: TAction
      Category = 'Toolbars'
      Caption = 'Object Inspector'
      ShortCut = 122
      OnExecute = InspectorTBCmdExecute
    end
    object DataTreeTBCmd: TAction
      Category = 'Toolbars'
      Caption = 'Data Tree'
      OnExecute = DataTreeTBCmdExecute
    end
    object ReportTreeTBCmd: TAction
      Category = 'Toolbars'
      Caption = 'Report Tree'
      OnExecute = ReportTreeTBCmdExecute
    end
    object ToolbarsCmd: TAction
      Category = 'Toolbars'
      Caption = 'Toolbars'
      OnExecute = ToolbarsCmdExecute
    end
    object SelectAllOfTypeCmd: TAction
      Category = 'Edit'
      Caption = 'SelectAllOfTypeCmd'
      OnExecute = SelectAllOfTypeCmdExecute
    end
    object EdConfigCmd: TAction
      Category = 'View'
      Caption = 'Editors configurator ..'
      OnExecute = EdConfigCmdExecute
    end
  end
  object BandsPopup: TPopupMenu
    OnPopup = BandsPopupPopup
    Left = 274
    Top = 316
    object ReportTitleMI: TMenuItem
      Caption = 'Report Title'
      OnClick = InsertBandClick
    end
    object ReportSummaryMI: TMenuItem
      Tag = 1
      Caption = 'Report Summary'
      OnClick = InsertBandClick
    end
    object PageHeaderMI: TMenuItem
      Tag = 2
      Caption = 'Page Header'
      OnClick = InsertBandClick
    end
    object PageFooterMI: TMenuItem
      Tag = 3
      Caption = 'Page Footer'
      OnClick = InsertBandClick
    end
    object HeaderMI: TMenuItem
      Tag = 4
      Caption = 'Header'
      OnClick = InsertBandClick
    end
    object FooterMI: TMenuItem
      Tag = 5
      Caption = 'Footer'
      OnClick = InsertBandClick
    end
    object MasterDataMI: TMenuItem
      Tag = 6
      Caption = 'Master Data'
      ImageIndex = 53
      OnClick = InsertBandClick
    end
    object DetailDataMI: TMenuItem
      Tag = 7
      Caption = 'Detail Data'
      ImageIndex = 53
      OnClick = InsertBandClick
    end
    object SubdetailDataMI: TMenuItem
      Tag = 8
      Caption = 'Subdetail Data'
      ImageIndex = 53
      OnClick = InsertBandClick
    end
    object Data4levelMI: TMenuItem
      Tag = 9
      Caption = 'Data 4th level'
      ImageIndex = 53
      OnClick = InsertBandClick
    end
    object Data5levelMI: TMenuItem
      Tag = 10
      Caption = 'Data 5th level'
      ImageIndex = 53
      OnClick = InsertBandClick
    end
    object Data6levelMI: TMenuItem
      Tag = 11
      Caption = 'Data 6th level'
      ImageIndex = 53
      OnClick = InsertBandClick
    end
    object GroupHeaderMI: TMenuItem
      Tag = 12
      Caption = 'Group Header'
      ImageIndex = 61
      OnClick = InsertBandClick
    end
    object GroupFooterMI: TMenuItem
      Tag = 13
      Caption = 'Group Footer'
      OnClick = InsertBandClick
    end
    object ChildMI: TMenuItem
      Tag = 14
      Caption = 'Child'
      OnClick = InsertBandClick
    end
    object ColumnHeaderMI: TMenuItem
      Tag = 15
      Caption = 'Column Header'
      OnClick = InsertBandClick
    end
    object ColumnFooterMI: TMenuItem
      Tag = 16
      Caption = 'Column Footer'
      OnClick = InsertBandClick
    end
    object OverlayMI: TMenuItem
      Tag = 17
      Caption = 'Overlay'
      OnClick = InsertBandClick
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object VerticalbandsMI: TMenuItem
      Caption = 'Vertical bands'
      object HeaderMI1: TMenuItem
        Tag = 104
        Caption = 'Header'
        OnClick = InsertBandClick
      end
      object FooterMI1: TMenuItem
        Tag = 105
        Caption = 'Footer'
        OnClick = InsertBandClick
      end
      object MasterDataMI1: TMenuItem
        Tag = 106
        Caption = 'Master Data'
        ImageIndex = 53
        OnClick = InsertBandClick
      end
      object DetailDataMI1: TMenuItem
        Tag = 107
        Caption = 'Detail Data'
        ImageIndex = 53
        OnClick = InsertBandClick
      end
      object SubdetailDataMI1: TMenuItem
        Tag = 108
        Caption = 'Subdetail Data'
        ImageIndex = 53
        OnClick = InsertBandClick
      end
      object GroupHeaderMI1: TMenuItem
        Tag = 112
        Caption = 'Group Header'
        ImageIndex = 61
        OnClick = InsertBandClick
      end
      object GroupFooterMI1: TMenuItem
        Tag = 113
        Caption = 'Group Footer'
        OnClick = InsertBandClick
      end
      object ChildMI1: TMenuItem
        Tag = 114
        Caption = 'Child'
        OnClick = InsertBandClick
      end
    end
  end
  object Timer: TTimer
    Enabled = False
    OnTimer = TimerTimer
    Left = 407
    Top = 336
  end
  object RotationPopup: TPopupMenu
    Left = 308
    Top = 316
    object R0MI: TMenuItem
      Tag = 30
      Caption = '0'
      OnClick = ToolButtonClick
    end
    object R45MI: TMenuItem
      Tag = 30
      Caption = '45'
      HelpContext = 45
      OnClick = ToolButtonClick
    end
    object R90MI: TMenuItem
      Tag = 30
      Caption = '90'
      HelpContext = 90
      OnClick = ToolButtonClick
    end
    object R180MI: TMenuItem
      Tag = 30
      Caption = '180'
      HelpContext = 180
      OnClick = ToolButtonClick
    end
    object R270MI: TMenuItem
      Tag = 30
      Caption = '270'
      HelpContext = 270
      OnClick = ToolButtonClick
    end
  end
  object OpenScriptDialog: TOpenDialog
    Left = 414
    Top = 144
  end
  object SaveScriptDialog: TSaveDialog
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 410
    Top = 176
  end
  object ObjectsPopup: TPopupMenu
    Left = 269
    Top = 284
  end
  object DMPPopup: TPopupMenu
    Left = 310
    Top = 284
    object BoldMI: TMenuItem
      Tag = 34
      Caption = 'Bold'
      OnClick = ToolButtonClick
    end
    object ItalicMI: TMenuItem
      Tag = 35
      Caption = 'Italic'
      OnClick = ToolButtonClick
    end
    object UnderlineMI: TMenuItem
      Tag = 36
      Caption = 'Underline'
      OnClick = ToolButtonClick
    end
    object SuperScriptMI: TMenuItem
      Tag = 37
      Caption = 'SuperScript'
      OnClick = ToolButtonClick
    end
    object SubScriptMI: TMenuItem
      Tag = 38
      Caption = 'SubScript'
      OnClick = ToolButtonClick
    end
    object CondensedMI: TMenuItem
      Tag = 39
      Caption = 'Condensed'
      OnClick = ToolButtonClick
    end
    object WideMI: TMenuItem
      Tag = 40
      Caption = 'Wide'
      OnClick = ToolButtonClick
    end
    object N12cpiMI: TMenuItem
      Tag = 41
      Caption = '12 cpi'
      OnClick = ToolButtonClick
    end
    object N15cpiMI: TMenuItem
      Tag = 42
      Caption = '15 cpi'
      OnClick = ToolButtonClick
    end
  end
  object FontColorPopupMenu: TPopupMenu
    OnPopup = FontColorPopupMenuPopup
    Left = 406
    Top = 59
  end
  object FillColorPopupMenu: TPopupMenu
    OnPopup = FillColorPopupMenuPopup
    Left = 854
    Top = 59
  end
  object FrameColorPopupMenu: TPopupMenu
    OnPopup = FrameColorPopupMenuPopup
    Left = 894
    Top = 59
  end
end
