object frxDataTreeForm: TfrxDataTreeForm
  Left = 224
  Top = 111
  Width = 327
  Height = 427
  BorderIcons = [biSystemMenu, biMinimize, biMaximize, biHelp]
  BorderStyle = bsSizeToolWin
  Caption = 'Data Fields'
  Color = clBtnFace
  DragKind = dkDock
  DragMode = dmAutomatic
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  KeyPreview = True
  OldCreateOrder = True
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object DataPn: TPanel
    Left = 10
    Top = 12
    Width = 181
    Height = 301
    BevelOuter = bvNone
    TabOrder = 0
    object DataTree: TTreeView
      Left = 0
      Top = 0
      Width = 181
      Height = 248
      Align = alClient
      BorderStyle = bsNone
      DragMode = dmAutomatic
      HideSelection = False
      Indent = 19
      ReadOnly = True
      ShowRoot = False
      TabOrder = 0
      OnCustomDrawItem = DataTreeCustomDrawItem
      OnDblClick = DataTreeDblClick
    end
    object CBPanel: TPanel
      Left = 0
      Top = 248
      Width = 181
      Height = 53
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 1
      Visible = False
      object InsFieldCB: TCheckBox
        Left = 0
        Top = 4
        Width = 145
        Height = 17
        Caption = 'Insert field'
        Checked = True
        State = cbChecked
        TabOrder = 0
      end
      object InsCaptionCB: TCheckBox
        Left = 0
        Top = 20
        Width = 145
        Height = 17
        Caption = 'Insert caption'
        TabOrder = 1
      end
      object SortCB: TCheckBox
        Left = 0
        Top = 36
        Width = 145
        Height = 17
        Caption = 'Sort Data Tree'
        TabOrder = 2
        OnClick = SortCBClick
      end
    end
    object NoDataPn: TScrollBox
      Left = 8
      Top = 8
      Width = 101
      Height = 41
      BorderStyle = bsNone
      Color = clWindow
      ParentColor = False
      TabOrder = 2
      object NoDataL: TLabel
        Left = 0
        Top = 0
        Width = 101
        Height = 41
        Align = alClient
        Alignment = taCenter
        AutoSize = False
        Caption = 'NoDataL'
        Transparent = True
        WordWrap = True
        OnDblClick = DataTreeDblClick
      end
    end
  end
  object VariablesPn: TPanel
    Left = 22
    Top = 28
    Width = 185
    Height = 269
    BevelOuter = bvNone
    TabOrder = 1
    Visible = False
    object VariablesTree: TTreeView
      Left = 0
      Top = 0
      Width = 185
      Height = 269
      Align = alClient
      BorderStyle = bsNone
      DragMode = dmAutomatic
      Indent = 19
      ReadOnly = True
      ShowRoot = False
      TabOrder = 0
      OnCustomDrawItem = DataTreeCustomDrawItem
      OnDblClick = DataTreeDblClick
    end
  end
  object FunctionsPn: TPanel
    Left = 38
    Top = 44
    Width = 185
    Height = 265
    BevelOuter = bvNone
    TabOrder = 2
    Visible = False
    object Splitter1: TSplitter
      Left = 0
      Top = 166
      Width = 185
      Height = 3
      Cursor = crVSplit
      Align = alBottom
    end
    object HintPanel: TScrollBox
      Left = 0
      Top = 169
      Width = 185
      Height = 96
      HorzScrollBar.Visible = False
      VertScrollBar.Visible = False
      Align = alBottom
      BorderStyle = bsNone
      Color = clWindow
      ParentColor = False
      TabOrder = 0
      object FunctionDescL: TLabel
        Left = 0
        Top = 42
        Width = 185
        Height = 54
        Align = alClient
        AutoSize = False
        Color = clWhite
        ParentColor = False
        ShowAccelChar = False
        WordWrap = True
      end
      object FunctionNameL: TLabel
        Left = 0
        Top = 0
        Width = 185
        Height = 42
        Align = alTop
        AutoSize = False
        Color = clInfoBk
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        ShowAccelChar = False
        WordWrap = True
      end
    end
    object FunctionsTree: TTreeView
      Left = 0
      Top = 0
      Width = 185
      Height = 166
      Align = alClient
      BorderStyle = bsNone
      DragMode = dmAutomatic
      Indent = 19
      ReadOnly = True
      ShowRoot = False
      TabOrder = 1
      OnChange = FunctionsTreeChange
      OnCustomDrawItem = DataTreeCustomDrawItem
      OnDblClick = DataTreeDblClick
    end
  end
  object ClassesPn: TPanel
    Left = 54
    Top = 64
    Width = 185
    Height = 261
    BevelOuter = bvNone
    TabOrder = 3
    Visible = False
    object ClassesTree: TTreeView
      Left = 0
      Top = 0
      Width = 185
      Height = 261
      Align = alClient
      BorderStyle = bsNone
      DragMode = dmAutomatic
      Indent = 19
      ReadOnly = True
      ShowRoot = False
      TabOrder = 0
      OnCustomDrawItem = ClassesTreeCustomDrawItem
      OnDblClick = DataTreeDblClick
      OnExpanding = ClassesTreeExpanding
    end
  end
end
