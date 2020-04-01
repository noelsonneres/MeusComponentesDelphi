object frxPageEditorForm: TfrxPageEditorForm
  Left = 256
  Top = 108
  BorderStyle = bsDialog
  Caption = 'Page options'
  ClientHeight = 410
  ClientWidth = 307
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
  OnHide = FormHide
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object OKB: TButton
    Left = 144
    Top = 380
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object CancelB: TButton
    Left = 226
    Top = 380
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object PageControl1: TPageControl
    Left = 8
    Top = 8
    Width = 293
    Height = 357
    ActivePage = TabSheet1
    TabOrder = 2
    object TabSheet1: TTabSheet
      Caption = 'Paper'
      object Label11: TGroupBox
        Left = 4
        Top = 4
        Width = 277
        Height = 101
        Caption = 'Size'
        TabOrder = 0
        object Label1: TLabel
          Left = 8
          Top = 48
          Width = 28
          Height = 13
          Caption = 'Width'
          FocusControl = WidthE
        end
        object Label2: TLabel
          Left = 8
          Top = 72
          Width = 31
          Height = 13
          Caption = 'Height'
          FocusControl = HeightE
        end
        object UnitL1: TLabel
          Left = 112
          Top = 48
          Width = 13
          Height = 13
          Caption = 'cm'
        end
        object UnitL2: TLabel
          Left = 112
          Top = 72
          Width = 13
          Height = 13
          Caption = 'cm'
        end
        object WidthE: TEdit
          Left = 64
          Top = 46
          Width = 45
          Height = 21
          AutoSize = False
          Ctl3D = True
          ParentCtl3D = False
          TabOrder = 1
          OnChange = WidthEChange
        end
        object HeightE: TEdit
          Left = 64
          Top = 70
          Width = 45
          Height = 21
          AutoSize = False
          Ctl3D = True
          ParentCtl3D = False
          TabOrder = 2
          OnChange = WidthEChange
        end
        object SizeCB: TComboBox
          Left = 8
          Top = 18
          Width = 261
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 0
          OnClick = SizeCBClick
        end
      end
      object Label14: TGroupBox
        Left = 4
        Top = 252
        Width = 277
        Height = 73
        Caption = 'Trays'
        TabOrder = 3
        object Label9: TLabel
          Left = 8
          Top = 20
          Width = 48
          Height = 13
          Caption = 'First page'
        end
        object Label10: TLabel
          Left = 8
          Top = 44
          Width = 60
          Height = 13
          Caption = 'Other pages'
        end
        object Tray1CB: TComboBox
          Left = 128
          Top = 18
          Width = 141
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 0
        end
        object Tray2CB: TComboBox
          Left = 128
          Top = 42
          Width = 141
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 1
        end
      end
      object Label12: TGroupBox
        Left = 4
        Top = 108
        Width = 277
        Height = 65
        Caption = 'Orientation'
        TabOrder = 1
        object PortraitImg: TImage
          Left = 148
          Top = 21
          Width = 26
          Height = 32
          AutoSize = True
          Picture.Data = {
            07544269746D617076020000424D760200000000000076000000280000001A00
            0000200000000100040000000000000200000000000000000000100000001000
            000000000000000080000080000000808000800000008000800080800000C0C0
            C000808080000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
            FF00E0000000000000000000000000000000E877777777777777777777777000
            0000E8FFFFFFFFFFFFFFFFFFFFFF70000000E8FFFFFFFFFFFFFFFFFFFFFF7000
            0000E8FFFFFFFFFFFFFFFFFFFFFF70000000E8FFFFFFFFFFFFFFFFFFFFFF7000
            0000E8FFFFFFFFFFFFFFFFFFFFFF70000000E8FFFFFFFFFFFFFFFFFFFFFF7000
            0000E8FFFFFFFFFFFFFFFFFFFFFF70000000E8FFFFFFFFFFFFFFFFFFFFFF7000
            0000E8FFFF8888FFFF888888FFFF70000000E8FFFFF78FFFFFF7887FFFFF7000
            0000E8FFFFFF87FFFFF888FFFFFF70000000E8FFFFFF787FFF7887FFFFFF7000
            0000E8FFFFFFF88888888FFFFFFF70000000E8FFFFFFF87FF7887FFFFFFF7000
            0000E8FFFFFFF78FF888FFFFFFFF70000000E8FFFFFFFF87F887FFFFFFFF7000
            0000E8FFFFFFFF78888FFFFFFFFF70000000E8FFFFFFFFF8887FFFFFFFFF7000
            0000E8FFFFFFFFF788FFFFFFFFFF70000000E8FFFFFFFFFF87FFFFFFFFFF7000
            0000E8FFFFFFFFFFFFFFFFFFFFFF70000000E8FFFFFFFFFFFFFFFFFFFFFF7000
            0000E8FFFFFFFFFFFFFFFFFFFFFF70000000E8FFFFFFFFFFFFFFFFF800000000
            0000E8FFFFFFFFFFFFFFFFF8FF780E000000E8FFFFFFFFFFFFFFFFF8F780EE00
            0000E8FFFFFFFFFFFFFFFFF8780EEE000000E8FFFFFFFFFFFFFFFFF880EEEE00
            0000E8FFFFFFFFFFFFFFFFF80EEEEE000000E8888888888888888888EEEEEE00
            0000}
          Transparent = True
        end
        object LandscapeImg: TImage
          Left = 145
          Top = 25
          Width = 32
          Height = 26
          AutoSize = True
          Picture.Data = {
            07544269746D617016020000424D160200000000000076000000280000002000
            00001A0000000100040000000000A00100000000000000000000100000001000
            000000000000000080000080000000808000800000008000800080800000C0C0
            C000808080000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
            FF00E0000000000000000000000000000000E877777777777777777777777777
            7770E8FFFFFFFFFFFFFFFFFFFFFFFFFFFF70E8FFFFFFFFFFFFFFFFFFFFFFFFFF
            FF70E8FFFFFFFFFFFFFFFFFFFFFFFFFFFF70E8FFFFFFFFFFFFFFFFFFFFFFFFFF
            FF70E8FFFFFFFFFFFFFFFFFFFFFFFFFFFF70E8FFFFFFF8888FFFF888888FFFFF
            FF70E8FFFFFFFF78FFFFFF7887FFFFFFFF70E8FFFFFFFFF87FFFFF888FFFFFFF
            FF70E8FFFFFFFFF787FFF7887FFFFFFFFF70E8FFFFFFFFFF88888888FFFFFFFF
            FF70E8FFFFFFFFFF87FF7887FFFFFFFFFF70E8FFFFFFFFFF78FF888FFFFFFFFF
            FF70E8FFFFFFFFFFF87F887FFFFFFFFFFF70E8FFFFFFFFFFF78888FFFFFFFFFF
            FF70E8FFFFFFFFFFFF8887FFFFFFFFFFFF70E8FFFFFFFFFFFF788FFFFFFFFFFF
            FF70E8FFFFFFFFFFFFF87FFFFFFFFFFFFF70E8FFFFFFFFFFFFFFFFFFFFFFF000
            0008E8FFFFFFFFFFFFFFFFFFFFFFF07FFF8EE8FFFFFFFFFFFFFFFFFFFFFFF07F
            F8EEE8FFFFFFFFFFFFFFFFFFFFFFF07F8EEEE8FFFFFFFFFFFFFFFFFFFFFFF0F8
            EEEEE8FFFFFFFFFFFFFFFFFFFFFFF08EEEEEE8888888888888888888888880EE
            EEEE}
          Transparent = True
        end
        object PortraitRB: TRadioButton
          Left = 8
          Top = 20
          Width = 109
          Height = 17
          Caption = 'Portrait'
          Checked = True
          TabOrder = 0
          TabStop = True
          OnClick = PortraitRBClick
        end
        object LandscapeRB: TRadioButton
          Left = 8
          Top = 40
          Width = 109
          Height = 17
          Caption = 'Landscape'
          TabOrder = 1
          OnClick = PortraitRBClick
        end
      end
      object Label13: TGroupBox
        Left = 4
        Top = 176
        Width = 277
        Height = 73
        Caption = 'Margins'
        TabOrder = 2
        object Label3: TLabel
          Left = 8
          Top = 20
          Width = 19
          Height = 13
          Caption = 'Left'
          FocusControl = MarginLeftE
        end
        object Label4: TLabel
          Left = 8
          Top = 44
          Width = 18
          Height = 13
          Caption = 'Top'
          FocusControl = MarginTopE
        end
        object Label5: TLabel
          Left = 152
          Top = 20
          Width = 25
          Height = 13
          Caption = 'Right'
          FocusControl = MarginRightE
        end
        object Label6: TLabel
          Left = 152
          Top = 44
          Width = 34
          Height = 13
          Caption = 'Bottom'
          FocusControl = MarginBottomE
        end
        object UnitL3: TLabel
          Left = 108
          Top = 20
          Width = 13
          Height = 13
          Caption = 'cm'
        end
        object UnitL4: TLabel
          Left = 108
          Top = 44
          Width = 13
          Height = 13
          Caption = 'cm'
        end
        object UnitL5: TLabel
          Left = 252
          Top = 20
          Width = 13
          Height = 13
          Caption = 'cm'
        end
        object UnitL6: TLabel
          Left = 252
          Top = 44
          Width = 13
          Height = 13
          Caption = 'cm'
        end
        object MarginLeftE: TEdit
          Left = 64
          Top = 18
          Width = 40
          Height = 21
          AutoSize = False
          Ctl3D = True
          ParentCtl3D = False
          TabOrder = 0
        end
        object MarginTopE: TEdit
          Left = 64
          Top = 42
          Width = 40
          Height = 21
          AutoSize = False
          Ctl3D = True
          ParentCtl3D = False
          TabOrder = 1
        end
        object MarginRightE: TEdit
          Left = 208
          Top = 18
          Width = 40
          Height = 21
          AutoSize = False
          Ctl3D = True
          ParentCtl3D = False
          TabOrder = 2
        end
        object MarginBottomE: TEdit
          Left = 208
          Top = 42
          Width = 40
          Height = 21
          AutoSize = False
          Ctl3D = True
          ParentCtl3D = False
          TabOrder = 3
        end
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Other Options'
      object Label7: TGroupBox
        Left = 4
        Top = 4
        Width = 277
        Height = 149
        Caption = 'Columns'
        TabOrder = 0
        object Label8: TLabel
          Left = 8
          Top = 20
          Width = 37
          Height = 13
          Caption = 'Number'
          FocusControl = ColumnsNumberE
        end
        object Label15: TLabel
          Left = 8
          Top = 44
          Width = 28
          Height = 13
          Caption = 'Width'
          FocusControl = ColumnWidthE
        end
        object Label16: TLabel
          Left = 8
          Top = 68
          Width = 42
          Height = 13
          Caption = 'Positions'
        end
        object UnitL7: TLabel
          Left = 136
          Top = 44
          Width = 13
          Height = 13
          Caption = 'cm'
        end
        object ColumnsNumberE: TEdit
          Left = 88
          Top = 18
          Width = 29
          Height = 21
          AutoSize = False
          Ctl3D = True
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 0
          Text = '0'
        end
        object ColumnWidthE: TEdit
          Left = 88
          Top = 42
          Width = 45
          Height = 21
          AutoSize = False
          Ctl3D = True
          ParentCtl3D = False
          TabOrder = 1
        end
        object ColumnPositionsM: TMemo
          Left = 88
          Top = 66
          Width = 113
          Height = 71
          Ctl3D = True
          ParentCtl3D = False
          TabOrder = 2
        end
        object UpDown1: TUpDown
          Left = 117
          Top = 18
          Width = 16
          Height = 21
          Associate = ColumnsNumberE
          TabOrder = 3
          OnClick = UpDown1Click
        end
      end
      object Label17: TGroupBox
        Left = 4
        Top = 156
        Width = 277
        Height = 169
        Caption = 'Other'
        TabOrder = 1
        object Label18: TLabel
          Left = 8
          Top = 132
          Width = 33
          Height = 13
          Caption = 'Duplex'
        end
        object PrintOnPrevCB: TCheckBox
          Left = 8
          Top = 20
          Width = 261
          Height = 17
          Caption = 'Print to previous page'
          TabOrder = 0
        end
        object MirrorMarginsCB: TCheckBox
          Left = 8
          Top = 40
          Width = 261
          Height = 17
          Caption = 'Mirror margins'
          TabOrder = 1
        end
        object LargeHeightCB: TCheckBox
          Left = 8
          Top = 100
          Width = 261
          Height = 17
          Caption = 'Large height in design mode'
          Ctl3D = True
          ParentCtl3D = False
          TabOrder = 4
        end
        object DuplexCB: TComboBox
          Left = 88
          Top = 130
          Width = 141
          Height = 21
          Style = csDropDownList
          ItemHeight = 0
          TabOrder = 5
        end
        object EndlessWidthCB: TCheckBox
          Left = 8
          Top = 60
          Width = 261
          Height = 17
          Caption = 'Endless page width'
          TabOrder = 2
        end
        object EndlessHeightCB: TCheckBox
          Left = 8
          Top = 80
          Width = 261
          Height = 17
          Caption = 'Endless page height'
          TabOrder = 3
        end
      end
    end
  end
end
