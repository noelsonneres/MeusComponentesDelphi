object frxWatchForm: TfrxWatchForm
  Left = 364
  Top = 345
  Width = 613
  Height = 258
  BorderStyle = bsSizeToolWin
  Caption = 'Watch list'
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
  OldCreateOrder = False
  Position = poDefault
  ShowHint = True
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object ToolBar1: TToolBar
    Left = 0
    Top = 0
    Width = 597
    Height = 30
    BorderWidth = 2
    Caption = 'ToolBar1'
    EdgeBorders = []
    Flat = True
    TabOrder = 0
    object AddB: TToolButton
      Left = 0
      Top = 0
      Hint = 'Add watch'
      ImageIndex = 97
      OnClick = AddBClick
    end
    object DeleteB: TToolButton
      Left = 23
      Top = 0
      Hint = 'Delete watch'
      ImageIndex = 98
      OnClick = DeleteBClick
    end
    object EditB: TToolButton
      Left = 46
      Top = 0
      Hint = 'Edit watch'
      ImageIndex = 68
      OnClick = EditBClick
    end
  end
  object WatchLBCB: TCheckListBox
    Left = 0
    Top = 30
    Width = 597
    Height = 170
    OnClickCheck = WatchLBCBClickCheck
    Align = alClient
    BorderStyle = bsNone
    ItemHeight = 13
    TabOrder = 1
    OnDblClick = EditBClick
  end
  object ListTB: TTabControl
    Left = 0
    Top = 200
    Width = 597
    Height = 20
    Align = alBottom
    TabOrder = 2
    TabPosition = tpBottom
    Tabs.Strings = (
      'Watches'
      'Local')
    TabIndex = 0
    OnChange = ListTBChange
  end
  object WatchLB: TStringGrid
    Left = 0
    Top = 30
    Width = 597
    Height = 170
    Align = alClient
    BorderStyle = bsNone
    ColCount = 3
    DefaultRowHeight = 18
    FixedCols = 0
    RowCount = 2
    GridLineWidth = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSelect]
    TabOrder = 3
  end
end
