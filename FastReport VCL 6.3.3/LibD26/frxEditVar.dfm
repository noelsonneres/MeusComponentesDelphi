object frxVarEditorForm: TfrxVarEditorForm
  Left = 201
  Top = 109
  Width = 532
  Height = 548
  BorderIcons = [biSystemMenu, biMinimize, biMaximize, biHelp]
  Caption = 'Edit Variables'
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
  OnDestroy = FormDestroy
  OnHide = FormHide
  OnKeyDown = FormKeyDown
  OnResize = Splitter2Moved
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 0
    Top = 431
    Width = 516
    Height = 3
    Cursor = crVSplit
    Align = alBottom
  end
  object Splitter2: TSplitter
    Left = 113
    Top = 31
    Height = 383
    Align = alRight
    OnMoved = Splitter2Moved
  end
  object VarTree: TTreeView
    Left = 0
    Top = 31
    Width = 113
    Height = 383
    HelpContext = 78
    Align = alClient
    BorderStyle = bsNone
    HideSelection = False
    Indent = 19
    ShowRoot = False
    TabOrder = 0
    OnChange = VarTreeChange
    OnChanging = VarTreeChanging
    OnEdited = VarTreeEdited
    OnKeyDown = VarTreeKeyDown
  end
  object ToolBar: TToolBar
    Left = 0
    Top = 0
    Width = 516
    Height = 31
    AutoSize = True
    BorderWidth = 2
    ButtonHeight = 23
    EdgeBorders = []
    Flat = True
    TabOrder = 1
    object NewCategoryB: TToolButton
      Left = 0
      Top = 0
      Caption = 'Category'
      ImageIndex = 65
      OnClick = NewCategoryBClick
    end
    object NewVarB: TToolButton
      Left = 23
      Top = 0
      Caption = 'Variable'
      ImageIndex = 67
      OnClick = NewVarBClick
    end
    object EditB: TToolButton
      Left = 46
      Top = 0
      Caption = 'Edit'
      ImageIndex = 68
      OnClick = EditBClick
    end
    object DeleteB: TToolButton
      Left = 69
      Top = 0
      Caption = 'Delete'
      ImageIndex = 81
      OnClick = DeleteBClick
    end
    object EditListB: TToolButton
      Left = 92
      Top = 0
      Caption = 'List'
      ImageIndex = 69
      OnClick = EditListBClick
    end
    object Sep2: TToolButton
      Left = 115
      Top = 0
      Width = 8
      ImageIndex = 59
      Style = tbsSeparator
    end
    object LoadB: TToolButton
      Left = 123
      Top = 0
      Caption = 'Load'
      ImageIndex = 1
      OnClick = LoadBClick
    end
    object SaveB: TToolButton
      Left = 146
      Top = 0
      Caption = 'Save'
      ImageIndex = 2
      OnClick = SaveBClick
    end
    object Sep1: TToolButton
      Left = 169
      Top = 0
      Width = 8
      ImageIndex = 7
      Style = tbsSeparator
    end
    object CancelB: TToolButton
      Left = 177
      Top = 0
      Caption = 'Cancel'
      ImageIndex = 55
      OnClick = CancelBClick
    end
    object OkB: TToolButton
      Left = 200
      Top = 0
      Caption = 'OK'
      ImageIndex = 56
      OnClick = OkBClick
    end
  end
  object ExprMemo: TMemo
    Left = 0
    Top = 434
    Width = 516
    Height = 76
    Align = alBottom
    BorderStyle = bsNone
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    WantReturns = False
    OnDragDrop = ExprMemoDragDrop
    OnDragOver = ExprMemoDragOver
  end
  object ExprPanel: TPanel
    Left = 0
    Top = 414
    Width = 516
    Height = 17
    Align = alBottom
    Alignment = taLeftJustify
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelOuter = bvNone
    Caption = ' Expression:'
    Constraints.MaxHeight = 17
    Constraints.MinHeight = 17
    TabOrder = 3
  end
  object Panel: TPanel
    Left = 116
    Top = 31
    Width = 400
    Height = 383
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 4
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = '.fd3'
    Left = 80
    Top = 128
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = '.fd3'
    Left = 116
    Top = 128
  end
end
