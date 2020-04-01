object frxBreakPointsForm: TfrxBreakPointsForm
  Left = 675
  Top = 395
  Width = 411
  Height = 158
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
  OnKeyDown = FormKeyDown
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object ToolBar1: TToolBar
    Left = 0
    Top = 0
    Width = 395
    Height = 30
    BorderWidth = 2
    Caption = 'ToolBar1'
    EdgeBorders = []
    Flat = True
    TabOrder = 0
    object DeleteB: TToolButton
      Left = 0
      Top = 0
      Hint = 'Delete watch'
      ImageIndex = 98
      OnClick = DeleteBClick
    end
    object EditB: TToolButton
      Left = 23
      Top = 0
      Hint = 'Edit watch'
      ImageIndex = 68
      OnClick = EditBClick
    end
    object ToggleEnableB: TToolButton
      Left = 46
      Top = 0
      ImageIndex = 94
      OnClick = ToggleEnableBClick
    end
  end
  object BreakPGR: TStringGrid
    Left = 0
    Top = 30
    Width = 395
    Height = 90
    Align = alClient
    ColCount = 3
    DefaultRowHeight = 16
    FixedCols = 0
    RowCount = 2
    GridLineWidth = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSelect]
    TabOrder = 1
    OnDblClick = BreakPGRDblClick
    OnDrawCell = BreakPGRDrawCell
    ColWidths = (
      85
      64
      140)
  end
  object EditBtn: TButton
    Left = 304
    Top = 40
    Width = 16
    Height = 16
    Caption = '...'
    TabOrder = 2
    Visible = False
  end
end
