object frxStdWizardForm: TfrxStdWizardForm
  Left = 202
  Top = 119
  BorderStyle = bsDialog
  Caption = 'Standard Report Wizard'
  ClientHeight = 317
  ClientWidth = 443
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Pages: TPageControl
    Left = 4
    Top = 4
    Width = 435
    Height = 277
    ActivePage = DataTab
    TabOrder = 0
    OnChange = PagesChange
    object DataTab: TTabSheet
      Caption = 'Data'
      ImageIndex = 5
      object Step1L: TLabel
        Left = 4
        Top = 8
        Width = 31
        Height = 13
        Caption = 'Step 1'
      end
      object TableL: TLabel
        Left = 4
        Top = 92
        Width = 69
        Height = 13
        Caption = 'Select a table:'
      end
      object orL: TLabel
        Left = 188
        Top = 144
        Width = 10
        Height = 13
        Caption = 'or'
      end
      object ConnectionL: TLabel
        Left = 4
        Top = 38
        Width = 136
        Height = 13
        Caption = 'Select database connection:'
      end
      object ConfigureConnB: TSpeedButton
        Left = 208
        Top = 56
        Width = 23
        Height = 22
        ParentShowHint = False
        ShowHint = True
        OnClick = ConfigureConnBClick
      end
      object ConnectionCB: TComboBox
        Left = 4
        Top = 56
        Width = 197
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 0
        OnClick = ConnectionCBClick
      end
      object TablesLB: TListBox
        Left = 4
        Top = 110
        Width = 145
        Height = 134
        ItemHeight = 13
        TabOrder = 1
        OnClick = TablesLBClick
      end
      object CreateQueryB: TButton
        Left = 224
        Top = 140
        Width = 149
        Height = 25
        Caption = 'Create a query...'
        TabOrder = 2
        OnClick = CreateQueryBClick
      end
    end
    object FieldsTab: TTabSheet
      Caption = 'Fields'
      object AddFieldB: TSpeedButton
        Left = 164
        Top = 88
        Width = 100
        Height = 25
        Caption = 'Add  >'
        OnClick = AddFieldBClick
      end
      object AddAllFieldsB: TSpeedButton
        Left = 164
        Top = 116
        Width = 100
        Height = 25
        Caption = 'Add all >>'
        OnClick = AddAllFieldsBClick
      end
      object RemoveFieldB: TSpeedButton
        Left = 164
        Top = 156
        Width = 100
        Height = 25
        Caption = '<  Remove'
        OnClick = RemoveFieldBClick
      end
      object RemoveAllFieldsB: TSpeedButton
        Left = 164
        Top = 184
        Width = 100
        Height = 25
        Caption = '<< Remove all'
        OnClick = RemoveAllFieldsBClick
      end
      object SelectedFieldsL: TLabel
        Left = 276
        Top = 38
        Width = 73
        Height = 13
        Caption = 'Selected fields:'
      end
      object FieldUpB: TSpeedButton
        Left = 387
        Top = 36
        Width = 17
        Height = 17
        Glyph.Data = {
          9E010000424D9E0100000000000036000000280000000B0000000A0000000100
          1800000000006801000000000000000000000000000000000000C0C0C0C0C0C0
          C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0000000C0C0
          C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C000
          0000C0C0C0C0C0C0C0C0C0000000000000000000000000000000C0C0C0C0C0C0
          C0C0C0000000C0C0C0C0C0C0C0C0C0000000000000000000000000000000C0C0
          C0C0C0C0C0C0C0000000C0C0C0C0C0C0C0C0C000000000000000000000000000
          0000C0C0C0C0C0C0C0C0C0000000C0C0C0000000000000000000000000000000
          000000000000000000000000C0C0C0000000C0C0C0C0C0C00000000000000000
          00000000000000000000000000C0C0C0C0C0C0000000C0C0C0C0C0C0C0C0C000
          0000000000000000000000000000C0C0C0C0C0C0C0C0C0000000C0C0C0C0C0C0
          C0C0C0C0C0C0000000000000000000C0C0C0C0C0C0C0C0C0C0C0C0000000C0C0
          C0C0C0C0C0C0C0C0C0C0C0C0C0000000C0C0C0C0C0C0C0C0C0C0C0C0C0C0C000
          0000}
        OnClick = FieldUpBClick
      end
      object FieldDownB: TSpeedButton
        Left = 404
        Top = 36
        Width = 17
        Height = 17
        Glyph.Data = {
          9E010000424D9E0100000000000036000000280000000B0000000A0000000100
          1800000000006801000000000000000000000000000000000000C0C0C0C0C0C0
          C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0000000C0C0
          C0C0C0C0C0C0C0C0C0C0C0C0C0000000C0C0C0C0C0C0C0C0C0C0C0C0C0C0C000
          0000C0C0C0C0C0C0C0C0C0C0C0C0000000000000000000C0C0C0C0C0C0C0C0C0
          C0C0C0000000C0C0C0C0C0C0C0C0C0000000000000000000000000000000C0C0
          C0C0C0C0C0C0C0000000C0C0C0C0C0C000000000000000000000000000000000
          0000000000C0C0C0C0C0C0000000C0C0C0000000000000000000000000000000
          000000000000000000000000C0C0C0000000C0C0C0C0C0C0C0C0C00000000000
          00000000000000000000C0C0C0C0C0C0C0C0C0000000C0C0C0C0C0C0C0C0C000
          0000000000000000000000000000C0C0C0C0C0C0C0C0C0000000C0C0C0C0C0C0
          C0C0C0000000000000000000000000000000C0C0C0C0C0C0C0C0C0000000C0C0
          C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C000
          0000}
        OnClick = FieldDownBClick
      end
      object Step2L: TLabel
        Left = 4
        Top = 8
        Width = 31
        Height = 13
        Caption = 'Step 2'
      end
      object AvailableFieldsL1: TLabel
        Left = 4
        Top = 38
        Width = 75
        Height = 13
        Caption = 'Available fields:'
      end
      object FieldsLB: TListBox
        Left = 4
        Top = 56
        Width = 145
        Height = 188
        ItemHeight = 13
        MultiSelect = True
        TabOrder = 0
      end
      object SelectedFieldsLB: TListBox
        Left = 276
        Top = 56
        Width = 145
        Height = 188
        ItemHeight = 13
        MultiSelect = True
        TabOrder = 1
      end
    end
    object GroupsTab: TTabSheet
      Caption = 'Groups'
      ImageIndex = 1
      OnShow = GroupsTabShow
      object AddGroupB: TSpeedButton
        Left = 164
        Top = 88
        Width = 100
        Height = 25
        Caption = 'Add  >'
        OnClick = AddGroupBClick
      end
      object RemoveGroupB: TSpeedButton
        Left = 164
        Top = 116
        Width = 100
        Height = 25
        Caption = '<  Remove'
        OnClick = RemoveGroupBClick
      end
      object GroupsL: TLabel
        Left = 276
        Top = 38
        Width = 38
        Height = 13
        Caption = 'Groups:'
      end
      object GroupUpB: TSpeedButton
        Left = 387
        Top = 36
        Width = 17
        Height = 17
        Glyph.Data = {
          9E010000424D9E0100000000000036000000280000000B0000000A0000000100
          1800000000006801000000000000000000000000000000000000C0C0C0C0C0C0
          C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0000000C0C0
          C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C000
          0000C0C0C0C0C0C0C0C0C0000000000000000000000000000000C0C0C0C0C0C0
          C0C0C0000000C0C0C0C0C0C0C0C0C0000000000000000000000000000000C0C0
          C0C0C0C0C0C0C0000000C0C0C0C0C0C0C0C0C000000000000000000000000000
          0000C0C0C0C0C0C0C0C0C0000000C0C0C0000000000000000000000000000000
          000000000000000000000000C0C0C0000000C0C0C0C0C0C00000000000000000
          00000000000000000000000000C0C0C0C0C0C0000000C0C0C0C0C0C0C0C0C000
          0000000000000000000000000000C0C0C0C0C0C0C0C0C0000000C0C0C0C0C0C0
          C0C0C0C0C0C0000000000000000000C0C0C0C0C0C0C0C0C0C0C0C0000000C0C0
          C0C0C0C0C0C0C0C0C0C0C0C0C0000000C0C0C0C0C0C0C0C0C0C0C0C0C0C0C000
          0000}
        OnClick = GroupUpBClick
      end
      object GroupDownB: TSpeedButton
        Left = 404
        Top = 36
        Width = 17
        Height = 17
        Glyph.Data = {
          9E010000424D9E0100000000000036000000280000000B0000000A0000000100
          1800000000006801000000000000000000000000000000000000C0C0C0C0C0C0
          C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0000000C0C0
          C0C0C0C0C0C0C0C0C0C0C0C0C0000000C0C0C0C0C0C0C0C0C0C0C0C0C0C0C000
          0000C0C0C0C0C0C0C0C0C0C0C0C0000000000000000000C0C0C0C0C0C0C0C0C0
          C0C0C0000000C0C0C0C0C0C0C0C0C0000000000000000000000000000000C0C0
          C0C0C0C0C0C0C0000000C0C0C0C0C0C000000000000000000000000000000000
          0000000000C0C0C0C0C0C0000000C0C0C0000000000000000000000000000000
          000000000000000000000000C0C0C0000000C0C0C0C0C0C0C0C0C00000000000
          00000000000000000000C0C0C0C0C0C0C0C0C0000000C0C0C0C0C0C0C0C0C000
          0000000000000000000000000000C0C0C0C0C0C0C0C0C0000000C0C0C0C0C0C0
          C0C0C0000000000000000000000000000000C0C0C0C0C0C0C0C0C0000000C0C0
          C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C000
          0000}
        OnClick = GroupDownBClick
      end
      object AvailableFieldsL: TLabel
        Left = 4
        Top = 38
        Width = 75
        Height = 13
        Caption = 'Available fields:'
      end
      object Step3L: TLabel
        Left = 4
        Top = 8
        Width = 31
        Height = 13
        Caption = 'Step 3'
      end
      object AvailableFieldsLB: TListBox
        Left = 4
        Top = 56
        Width = 145
        Height = 188
        ItemHeight = 13
        TabOrder = 0
      end
      object GroupsLB: TListBox
        Left = 276
        Top = 56
        Width = 145
        Height = 188
        ItemHeight = 13
        TabOrder = 1
      end
    end
    object LayoutTab: TTabSheet
      Caption = 'Layout'
      ImageIndex = 2
      object Step4L: TLabel
        Left = 4
        Top = 8
        Width = 31
        Height = 13
        Caption = 'Step 4'
      end
      object FitWidthCB: TCheckBox
        Left = 4
        Top = 220
        Width = 209
        Height = 17
        Caption = 'Fit fields to page width'
        Checked = True
        State = cbChecked
        TabOrder = 0
      end
      object OrientationL: TGroupBox
        Left = 4
        Top = 32
        Width = 173
        Height = 65
        Caption = 'Orientation'
        TabOrder = 1
        object PortraitImg: TImage
          Left = 132
          Top = 19
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
          Left = 129
          Top = 23
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
          Visible = False
        end
        object PortraitRB: TRadioButton
          Left = 8
          Top = 18
          Width = 109
          Height = 17
          HelpContext = 111
          Caption = 'Portrait'
          Checked = True
          TabOrder = 0
          TabStop = True
          OnClick = PortraitRBClick
        end
        object LandscapeRB: TRadioButton
          Left = 8
          Top = 38
          Width = 109
          Height = 17
          HelpContext = 120
          Caption = 'Landscape'
          TabOrder = 1
          OnClick = PortraitRBClick
        end
      end
      object LayoutL: TGroupBox
        Left = 4
        Top = 104
        Width = 173
        Height = 65
        Caption = 'Layout'
        TabOrder = 2
        object TabularRB: TRadioButton
          Left = 8
          Top = 18
          Width = 133
          Height = 17
          HelpContext = 111
          Caption = 'Tabular'
          Checked = True
          TabOrder = 0
          TabStop = True
          OnClick = TabularRBClick
        end
        object ColumnarRB: TRadioButton
          Left = 8
          Top = 38
          Width = 133
          Height = 17
          HelpContext = 120
          Caption = 'Columnar'
          TabOrder = 1
          OnClick = TabularRBClick
        end
      end
      object ScrollBox2: TScrollBox
        Left = 184
        Top = 36
        Width = 237
        Height = 209
        AutoScroll = False
        Color = clGray
        ParentColor = False
        TabOrder = 3
        object LayoutPB: TPaintBox
          Left = 12
          Top = 12
          Width = 228
          Height = 198
          OnPaint = LayoutPBPaint
        end
      end
    end
    object StyleTab: TTabSheet
      Caption = 'Style'
      ImageIndex = 3
      object Step5L: TLabel
        Left = 4
        Top = 8
        Width = 31
        Height = 13
        Caption = 'Step 5'
      end
      object ScrollBox1: TScrollBox
        Left = 156
        Top = 36
        Width = 265
        Height = 209
        AutoScroll = False
        Color = clGray
        ParentColor = False
        TabOrder = 0
        object StylePB: TPaintBox
          Left = 12
          Top = 12
          Width = 267
          Height = 201
          OnPaint = StylePBPaint
        end
      end
      object StyleLB: TListBox
        Left = 4
        Top = 36
        Width = 145
        Height = 209
        ItemHeight = 13
        TabOrder = 1
        OnClick = StyleLBClick
      end
    end
  end
  object BackB: TButton
    Left = 196
    Top = 288
    Width = 75
    Height = 25
    Caption = '<< Back'
    Enabled = False
    TabOrder = 1
    OnClick = BackBClick
  end
  object NextB: TButton
    Left = 276
    Top = 288
    Width = 75
    Height = 25
    Caption = 'Next >>'
    TabOrder = 2
    OnClick = NextBClick
  end
  object FinishB: TButton
    Left = 364
    Top = 288
    Width = 75
    Height = 25
    Caption = 'Finish'
    ModalResult = 1
    TabOrder = 3
    OnClick = FinishBClick
  end
end
