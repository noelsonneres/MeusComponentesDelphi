object frxCrossEditorForm: TfrxCrossEditorForm
  Left = 780
  Top = 169
  Width = 920
  Height = 767
  Caption = 'Cross-tab Editor'
  Color = clBtnFace
  Constraints.MinHeight = 767
  Constraints.MinWidth = 920
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  ShowHint = True
  OnCreate = FormCreate
  OnHide = FormHide
  OnKeyDown = FormKeyDown
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 120
  TextHeight = 17
  object StructurePn: TPanel
    Left = 0
    Top = 0
    Width = 902
    Height = 276
    Align = alTop
    BevelOuter = bvNone
    Constraints.MinHeight = 276
    TabOrder = 0
    DesignSize = (
      902
      276)
    object DatasetL: TGroupBox
      Left = 5
      Top = 5
      Width = 216
      Height = 268
      Anchors = [akLeft, akTop, akBottom]
      Caption = 'Dataset'
      Constraints.MinWidth = 216
      TabOrder = 0
      DesignSize = (
        216
        268)
      object DatasetCB: TComboBox
        Left = 16
        Top = 26
        Width = 184
        Height = 22
        Style = csOwnerDrawFixed
        Anchors = [akLeft, akTop, akRight]
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ItemHeight = 16
        ParentFont = False
        TabOrder = 0
        OnClick = DatasetCBClick
        OnDrawItem = DatasetCBDrawItem
      end
      object FieldsLB: TListBox
        Left = 16
        Top = 63
        Width = 184
        Height = 191
        Style = lbOwnerDrawFixed
        Anchors = [akLeft, akTop, akRight, akBottom]
        DragMode = dmAutomatic
        ItemHeight = 16
        TabOrder = 1
        OnClick = LBClick
        OnDragDrop = LBDragDrop
        OnDragOver = LBDragOver
        OnDrawItem = FieldsLBDrawItem
      end
      object DimensionsL: TGroupBox
        Left = 0
        Top = 0
        Width = 216
        Height = 268
        Anchors = [akLeft, akTop, akRight, akBottom]
        Caption = 'Dimensions'
        TabOrder = 2
        Visible = False
        object RowsL: TLabel
          Left = 16
          Top = 26
          Width = 33
          Height = 17
          Caption = 'Rows'
        end
        object ColumnsL: TLabel
          Left = 16
          Top = 63
          Width = 53
          Height = 17
          Caption = 'Columns'
        end
        object CellsL: TLabel
          Left = 16
          Top = 99
          Width = 26
          Height = 17
          Caption = 'Cells'
        end
        object RowsE: TEdit
          Left = 131
          Top = 21
          Width = 43
          Height = 25
          TabOrder = 0
          Text = '0'
          OnChange = DimensionsChange
        end
        object ColumnsE: TEdit
          Tag = 1
          Left = 131
          Top = 58
          Width = 43
          Height = 25
          TabOrder = 1
          Text = '0'
          OnChange = DimensionsChange
        end
        object CellsE: TEdit
          Tag = 2
          Left = 131
          Top = 94
          Width = 43
          Height = 25
          TabOrder = 2
          Text = '1'
          OnChange = DimensionsChange
        end
        object UpDown1: TUpDown
          Left = 174
          Top = 21
          Width = 20
          Height = 25
          Associate = RowsE
          TabOrder = 3
        end
        object UpDown2: TUpDown
          Left = 174
          Top = 58
          Width = 20
          Height = 25
          Associate = ColumnsE
          TabOrder = 4
        end
        object UpDown3: TUpDown
          Left = 174
          Top = 94
          Width = 20
          Height = 25
          Associate = CellsE
          Min = 1
          Position = 1
          TabOrder = 5
        end
      end
    end
    object StructureL: TGroupBox
      Left = 224
      Top = 5
      Width = 673
      Height = 268
      Anchors = [akLeft, akTop, akRight, akBottom]
      Caption = 'Cross-tab structure'
      TabOrder = 1
      object Shape2: TShape
        Left = 329
        Top = 19
        Width = 1
        Height = 247
        Align = alLeft
        Brush.Color = clBtnFace
        Pen.Style = psDot
      end
      object StructureLeftPn: TPanel
        Left = 2
        Top = 19
        Width = 327
        Height = 247
        Align = alLeft
        BevelOuter = bvNone
        TabOrder = 0
        object SwapPn: TPanel
          Left = 0
          Top = 0
          Width = 327
          Height = 123
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 0
          DesignSize = (
            327
            123)
          object Shape3: TShape
            Left = 0
            Top = 122
            Width = 327
            Height = 1
            Align = alBottom
            Brush.Color = clBtnFace
            Pen.Style = psDot
          end
          object SwapB: TSpeedButton
            Left = 284
            Top = 76
            Width = 35
            Height = 34
            Anchors = [akRight, akBottom]
            Glyph.Data = {
              5A010000424D5A01000000000000760000002800000013000000130000000100
              040000000000E400000000000000000000001000000000000000000000000000
              8000008000000080800080000000800080008080000080808000C0C0C0000000
              FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
              888888800000CCCCCCCCCC88888888800000CCCCCCCCCC88888888800000CCFF
              FFFFCC88888888800000CCCCCCCCCC88888888800000CCCCCCCCCC8888888880
              0000888888888888888888800000888888000888888888800000888888008888
              8888888000008888880808888888888000008888888880808888888000008888
              8888880088888880000088888888800088888880000088888888888888888880
              00008888888844444444448000008888888844444444448000008888888844FF
              FFFF44800000888888884444444444800000888888884444444444800000}
            OnClick = SwapBClick
          end
        end
        object RowsPn: TPanel
          Left = 0
          Top = 123
          Width = 327
          Height = 124
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 1
          DesignSize = (
            327
            124)
          object RowsLB: TListBox
            Left = 6
            Top = 8
            Width = 315
            Height = 106
            Style = lbOwnerDrawFixed
            Anchors = [akLeft, akTop, akRight, akBottom]
            DragMode = dmAutomatic
            ExtendedSelect = False
            ItemHeight = 16
            TabOrder = 0
            OnClick = LBClick
            OnDblClick = LBDblClick
            OnDragDrop = LBDragDrop
            OnDragOver = LBDragOver
            OnDrawItem = LBDrawItem
            OnMouseDown = LBMouseDown
          end
        end
      end
      object StructureRightPn: TPanel
        Left = 330
        Top = 19
        Width = 341
        Height = 247
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 1
        object ColumnsPn: TPanel
          Left = 0
          Top = 0
          Width = 341
          Height = 123
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 0
          DesignSize = (
            341
            123)
          object Shape1: TShape
            Left = 0
            Top = 122
            Width = 320
            Height = 1
            Anchors = [akLeft, akRight, akBottom]
            Brush.Color = clBtnFace
            Pen.Style = psDot
          end
          object ColumnsLB: TListBox
            Left = 8
            Top = 8
            Width = 315
            Height = 106
            Style = lbOwnerDrawFixed
            Anchors = [akLeft, akTop, akRight, akBottom]
            DragMode = dmAutomatic
            ExtendedSelect = False
            ItemHeight = 16
            TabOrder = 0
            OnClick = LBClick
            OnDblClick = LBDblClick
            OnDragDrop = LBDragDrop
            OnDragOver = LBDragOver
            OnDrawItem = LBDrawItem
            OnMouseDown = LBMouseDown
          end
        end
        object CellsPn: TPanel
          Left = 0
          Top = 123
          Width = 341
          Height = 124
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 1
          DesignSize = (
            341
            124)
          object CellsLB: TListBox
            Left = 8
            Top = 8
            Width = 315
            Height = 106
            Style = lbOwnerDrawFixed
            Anchors = [akLeft, akTop, akRight, akBottom]
            DragMode = dmAutomatic
            ExtendedSelect = False
            ItemHeight = 16
            TabOrder = 0
            OnClick = LBClick
            OnDblClick = LBDblClick
            OnDragDrop = LBDragDrop
            OnDragOver = LBDragOver
            OnDrawItem = CellsLBDrawItem
            OnMouseUp = CellsLBMouseUp
          end
        end
      end
    end
  end
  object OptionsPn: TPanel
    Left = 0
    Top = 276
    Width = 902
    Height = 383
    Align = alClient
    BevelOuter = bvNone
    Constraints.MinHeight = 380
    TabOrder = 1
    DesignSize = (
      902
      383)
    object OptionsL: TGroupBox
      Left = 5
      Top = 0
      Width = 892
      Height = 383
      Anchors = [akLeft, akTop, akRight, akBottom]
      TabOrder = 0
      DesignSize = (
        892
        383)
      object RowHeaderCB: TCheckBox
        Left = 561
        Top = 99
        Width = 310
        Height = 23
        Anchors = [akTop, akRight]
        Caption = 'Row header'
        TabOrder = 3
        OnClick = CBClick
      end
      object ColumnHeaderCB: TCheckBox
        Left = 561
        Top = 73
        Width = 310
        Height = 22
        Anchors = [akTop, akRight]
        Caption = 'Column header'
        TabOrder = 2
        OnClick = CBClick
      end
      object RowTotalCB: TCheckBox
        Left = 561
        Top = 152
        Width = 310
        Height = 22
        Anchors = [akTop, akRight]
        Caption = 'Row grand total'
        TabOrder = 5
        OnClick = CBClick
      end
      object ColumnTotalCB: TCheckBox
        Left = 561
        Top = 126
        Width = 310
        Height = 22
        Anchors = [akTop, akRight]
        Caption = 'Column grand total'
        TabOrder = 4
        OnClick = CBClick
      end
      object TitleCB: TCheckBox
        Left = 561
        Top = 21
        Width = 310
        Height = 22
        Anchors = [akTop, akRight]
        Caption = 'Show title'
        TabOrder = 0
        OnClick = CBClick
      end
      object CornerCB: TCheckBox
        Left = 561
        Top = 47
        Width = 310
        Height = 22
        Anchors = [akTop, akRight]
        Caption = 'Show corner'
        TabOrder = 1
        OnClick = CBClick
      end
      object AutoSizeCB: TCheckBox
        Left = 561
        Top = 199
        Width = 310
        Height = 22
        Anchors = [akTop, akRight]
        Caption = 'Auto size'
        TabOrder = 6
        OnClick = CBClick
      end
      object BorderCB: TCheckBox
        Left = 561
        Top = 225
        Width = 310
        Height = 22
        Anchors = [akTop, akRight]
        Caption = 'Border around cells'
        TabOrder = 7
        OnClick = CBClick
      end
      object DownAcrossCB: TCheckBox
        Left = 561
        Top = 251
        Width = 310
        Height = 22
        Anchors = [akTop, akRight]
        Caption = 'Print down then across'
        TabOrder = 8
        OnClick = CBClick
      end
      object PlainCB: TCheckBox
        Left = 561
        Top = 303
        Width = 310
        Height = 23
        Anchors = [akTop, akRight]
        Caption = 'Side-by-side cells'
        TabOrder = 10
        OnClick = CBClick
      end
      object JoinCB: TCheckBox
        Left = 561
        Top = 330
        Width = 310
        Height = 22
        Anchors = [akTop, akRight]
        Caption = 'Join equal cells'
        TabOrder = 11
        OnClick = CBClick
      end
      object Box: TScrollBox
        Left = 16
        Top = 21
        Width = 526
        Height = 346
        Anchors = [akLeft, akTop, akRight, akBottom]
        BorderStyle = bsNone
        Color = clWindow
        ParentColor = False
        TabOrder = 12
        DesignSize = (
          526
          346)
        object PaintBox: TPaintBox
          Left = 21
          Top = 31
          Width = 500
          Height = 310
          Anchors = [akLeft, akTop, akRight, akBottom]
          OnPaint = PaintBoxPaint
        end
        object ToolBar: TToolBar
          Left = 0
          Top = 0
          Width = 526
          Height = 22
          ButtonHeight = 25
          ButtonWidth = 45
          EdgeBorders = []
          Flat = True
          Indent = 16
          ShowCaptions = True
          TabOrder = 0
          object StyleB: TToolButton
            Left = 16
            Top = 0
            Caption = 'StyleB'
            DropdownMenu = StylePopup
            ImageIndex = 0
          end
        end
      end
      object RepeatCB: TCheckBox
        Left = 561
        Top = 277
        Width = 310
        Height = 22
        Anchors = [akTop, akRight]
        Caption = 'RepeatCB'
        TabOrder = 9
        OnClick = CBClick
      end
    end
  end
  object ButtonsPn: TPanel
    Left = 0
    Top = 659
    Width = 902
    Height = 61
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    DesignSize = (
      902
      61)
    object OkB: TButton
      Left = 676
      Top = 12
      Width = 98
      Height = 33
      Anchors = [akRight, akBottom]
      Caption = 'OK'
      Default = True
      ModalResult = 1
      TabOrder = 0
    end
    object CancelB: TButton
      Left = 788
      Top = 12
      Width = 98
      Height = 33
      Anchors = [akRight, akBottom]
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
    end
  end
  object FuncPopup: TPopupMenu
    Left = 174
    Top = 366
    object Func1MI: TMenuItem
      Caption = 'None'
      Checked = True
      GroupIndex = 1
      RadioItem = True
      OnClick = FuncMIClick
    end
    object Func2MI: TMenuItem
      Tag = 1
      Caption = 'Sum'
      GroupIndex = 1
      RadioItem = True
      OnClick = FuncMIClick
    end
    object Func3MI: TMenuItem
      Tag = 2
      Caption = 'Min'
      GroupIndex = 1
      RadioItem = True
      OnClick = FuncMIClick
    end
    object Func4MI: TMenuItem
      Tag = 3
      Caption = 'Max'
      GroupIndex = 1
      RadioItem = True
      OnClick = FuncMIClick
    end
    object Func5MI: TMenuItem
      Tag = 4
      Caption = 'Avg'
      GroupIndex = 1
      RadioItem = True
      OnClick = FuncMIClick
    end
    object Func6MI: TMenuItem
      Tag = 5
      Caption = 'Count'
      GroupIndex = 1
      RadioItem = True
      OnClick = FuncMIClick
    end
  end
  object SortPopup: TPopupMenu
    Left = 214
    Top = 366
    object Sort1MI: TMenuItem
      Caption = 'Asc'
      GroupIndex = 1
      RadioItem = True
      OnClick = SortMIClick
    end
    object Sort2MI: TMenuItem
      Tag = 1
      Caption = 'Desc'
      GroupIndex = 1
      RadioItem = True
      OnClick = SortMIClick
    end
    object Sort3MI: TMenuItem
      Tag = 2
      Caption = 'None'
      GroupIndex = 1
      RadioItem = True
      OnClick = SortMIClick
    end
    object Sort4MI: TMenuItem
      Tag = 3
      Caption = 'Group'
      GroupIndex = 1
      RadioItem = True
      OnClick = SortMIClick
    end
  end
  object StylePopup: TPopupMenu
    Left = 132
    Top = 364
    object Sep1: TMenuItem
      Caption = '-'
    end
    object SaveStyleMI: TMenuItem
      Caption = 'Save style...'
      ImageIndex = 0
      OnClick = SaveStyleMIClick
    end
  end
end
