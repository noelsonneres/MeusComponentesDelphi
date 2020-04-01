object frxChartEditorForm: TfrxChartEditorForm
  Left = 389
  Top = 194
  AutoScroll = False
  BorderIcons = [biSystemMenu]
  Caption = 'Chart Editor'
  ClientHeight = 444
  ClientWidth = 527
  Color = clBtnFace
  Constraints.MinHeight = 478
  Constraints.MinWidth = 535
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
  DesignSize = (
    527
    444)
  PixelsPerInch = 96
  TextHeight = 13
  object HintL: TLabel
    Left = 276
    Top = 172
    Width = 198
    Height = 13
    Alignment = taCenter
    Caption = 'Select the chart series or add a new one.'
  end
  object OkB: TButton
    Left = 367
    Top = 415
    Width = 75
    Height = 25
    HelpContext = 40
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 0
    OnClick = OkBClick
  end
  object Panel1: TPanel
    Left = 2
    Top = 2
    Width = 217
    Height = 439
    BevelOuter = bvNone
    TabOrder = 1
    object Panel2: TPanel
      Left = 0
      Top = 127
      Width = 217
      Height = 8
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
    end
    object InspSite: TPanel
      Left = 0
      Top = 135
      Width = 217
      Height = 304
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
    end
    object Panel3: TPanel
      Left = 0
      Top = 0
      Width = 217
      Height = 127
      Align = alTop
      BevelOuter = bvLowered
      Caption = 'Panel3'
      TabOrder = 2
      object ChartTree: TTreeView
        Left = 1
        Top = 1
        Width = 185
        Height = 125
        Align = alClient
        BorderStyle = bsNone
        HideSelection = False
        Images = ChartImages
        Indent = 27
        ParentShowHint = False
        ShowHint = False
        TabOrder = 0
        OnChange = ChartTreeChange
        OnClick = ChartTreeClick
        OnEdited = ChartTreeEdited
        OnEditing = ChartTreeEditing
        Items.Data = {
          010000001E000000000000000000000000000000FFFFFFFF0000000000000000
          054368617274}
      end
      object TreePanel: TPanel
        Left = 186
        Top = 1
        Width = 30
        Height = 125
        Align = alRight
        BevelOuter = bvNone
        TabOrder = 1
        object AddB: TSpeedButton
          Left = 4
          Top = 4
          Width = 23
          Height = 22
          Hint = 'Add Series'
          Flat = True
          Glyph.Data = {
            F6000000424DF600000000000000760000002800000010000000100000000100
            0400000000008000000000000000000000001000000010000000000000000000
            80000080000000808000800000008000800080800000C0C0C000808080000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777788
            877777777777788AA877777777778B8AAA8777777778BBB8AAA877777778BBB8
            888877777778BB8999987777B377889999877777B377789998777777B3777788
            87777777B377777777773333B33333777777BBBBBBBBBB7777777777B3777777
            77777777B377777777777777B377777777777777B37777777777}
          OnClick = AddBClick
        end
        object DeleteB: TSpeedButton
          Left = 4
          Top = 28
          Width = 23
          Height = 22
          Hint = 'Delete Series'
          Flat = True
          Glyph.Data = {
            F6000000424DF600000000000000760000002800000010000000100000000100
            0400000000008000000000000000000000001000000010000000000000000000
            80000080000000808000800000008000800080800000C0C0C000808080000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777788
            877777777777788AA877777777778B8AAA8777777778BBB8AAA877777778BBB8
            888877777778BB89999877777777889999877777777778999877777777777788
            8777777777777777777711111111117777779999999999777777777777777777
            7777777777777777777777777777777777777777777777777777}
          OnClick = DeleteBClick
        end
        object EditB: TSpeedButton
          Left = 4
          Top = 100
          Width = 23
          Height = 22
          Flat = True
          Glyph.Data = {
            F6000000424DF600000000000000760000002800000010000000100000000100
            0400000000008000000000000000000000001000000010000000000000000000
            8000008000000080800080000000800080008080000080808000C0C0C0000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888877
            788888888888877AA788888888887B7AAA7888888887BBB7AAA788888887BBB7
            777788828887BB799997882A28887799997882AAA288879997888AA8AA288877
            788888828AA288888888882A28AA8888888882AAA28A888888888AA8AA288888
            888888888AA288888888888888AA888888888888888888888888}
          Visible = False
          OnClick = EditBClick
        end
        object UPB: TSpeedButton
          Left = 4
          Top = 52
          Width = 23
          Height = 22
          Hint = 'Move Series Up'
          Flat = True
          Glyph.Data = {
            76010000424D7601000000000000760000002800000020000000100000000100
            04000000000000010000120B0000120B00001000000000000000000000000000
            800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333000333
            3333333333777F33333333333309033333333333337F7F333333333333090333
            33333333337F7F33333333333309033333333333337F7F333333333333090333
            33333333337F7F33333333333309033333333333FF7F7FFFF333333000090000
            3333333777737777F333333099999990333333373F3333373333333309999903
            333333337F33337F33333333099999033333333373F333733333333330999033
            3333333337F337F3333333333099903333333333373F37333333333333090333
            33333333337F7F33333333333309033333333333337373333333333333303333
            333333333337F333333333333330333333333333333733333333}
          NumGlyphs = 2
          OnClick = UPBClick
        end
        object DownB: TSpeedButton
          Left = 4
          Top = 76
          Width = 23
          Height = 22
          Hint = 'Move Series Down'
          Flat = True
          Glyph.Data = {
            76010000424D7601000000000000760000002800000020000000100000000100
            04000000000000010000120B0000120B00001000000000000000000000000000
            800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333303333
            333333333337F33333333333333033333333333333373F333333333333090333
            33333333337F7F33333333333309033333333333337373F33333333330999033
            3333333337F337F33333333330999033333333333733373F3333333309999903
            333333337F33337F33333333099999033333333373333373F333333099999990
            33333337FFFF3FF7F33333300009000033333337777F77773333333333090333
            33333333337F7F33333333333309033333333333337F7F333333333333090333
            33333333337F7F33333333333309033333333333337F7F333333333333090333
            33333333337F7F33333333333300033333333333337773333333}
          NumGlyphs = 2
          OnClick = DownBClick
        end
      end
    end
  end
  object CancelB: TButton
    Left = 447
    Top = 415
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object SourcePanel: TPanel
    Left = 224
    Top = 0
    Width = 305
    Height = 407
    Anchors = [akLeft, akTop, akRight]
    BevelOuter = bvNone
    TabOrder = 3
    DesignSize = (
      305
      407)
    object DataSourceGB: TGroupBox
      Left = 8
      Top = 0
      Width = 293
      Height = 99
      Anchors = [akLeft, akTop, akRight]
      Caption = 'Data Source'
      TabOrder = 0
      DesignSize = (
        293
        99)
      object DBSourceRB: TRadioButton
        Left = 8
        Top = 20
        Width = 109
        Height = 17
        Caption = 'Dataset'
        TabOrder = 0
        OnClick = DBSourceRBClick
      end
      object BandSourceRB: TRadioButton
        Left = 8
        Top = 44
        Width = 109
        Height = 17
        Caption = 'Data band'
        TabOrder = 1
        OnClick = DBSourceRBClick
      end
      object FixedDataRB: TRadioButton
        Left = 8
        Top = 68
        Width = 153
        Height = 17
        Caption = 'Fixed Data'
        TabOrder = 2
        OnClick = DBSourceRBClick
      end
      object DatasetsCB: TComboBox
        Tag = 2
        Left = 120
        Top = 21
        Width = 165
        Height = 21
        Style = csDropDownList
        Anchors = [akLeft, akRight]
        ItemHeight = 13
        TabOrder = 3
        OnClick = DatasetsCBClick
      end
      object DatabandsCB: TComboBox
        Tag = 6
        Left = 120
        Top = 45
        Width = 165
        Height = 21
        Style = csDropDownList
        Anchors = [akLeft, akRight]
        ItemHeight = 13
        TabOrder = 4
        OnClick = DatabandsCBClick
      end
    end
    object ValuesGB: TGroupBox
      Left = 8
      Top = 104
      Width = 293
      Height = 171
      Anchors = [akLeft, akTop, akRight, akBottom]
      Caption = 'Values'
      TabOrder = 1
      DesignSize = (
        293
        171)
      object Values1L: TLabel
        Left = 12
        Top = 20
        Width = 40
        Height = 13
        Caption = 'Values 1'
      end
      object Values2L: TLabel
        Left = 12
        Top = 44
        Width = 40
        Height = 13
        Caption = 'Values 1'
      end
      object Values3L: TLabel
        Left = 12
        Top = 68
        Width = 40
        Height = 13
        Caption = 'Values 1'
      end
      object Values4L: TLabel
        Left = 12
        Top = 92
        Width = 40
        Height = 13
        Caption = 'Values 1'
      end
      object Values5L: TLabel
        Left = 12
        Top = 116
        Width = 40
        Height = 13
        Caption = 'Values 1'
      end
      object Values6L: TLabel
        Left = 12
        Top = 140
        Width = 40
        Height = 13
        Caption = 'Values 1'
      end
      object Values1CB: TComboBox
        Tag = 3
        Left = 120
        Top = 16
        Width = 165
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        ItemHeight = 13
        TabOrder = 0
        OnChange = DoClick
      end
      object Values2CB: TComboBox
        Tag = 3
        Left = 120
        Top = 40
        Width = 165
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        ItemHeight = 13
        TabOrder = 1
        OnChange = DoClick
      end
      object Values3CB: TComboBox
        Tag = 3
        Left = 120
        Top = 64
        Width = 165
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        ItemHeight = 13
        TabOrder = 2
        OnChange = DoClick
      end
      object Values4CB: TComboBox
        Tag = 3
        Left = 120
        Top = 88
        Width = 165
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        ItemHeight = 13
        TabOrder = 3
        OnChange = DoClick
      end
      object Values5CB: TComboBox
        Tag = 3
        Left = 120
        Top = 112
        Width = 165
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        ItemHeight = 13
        TabOrder = 4
        OnChange = DoClick
      end
      object Values6CB: TComboBox
        Tag = 3
        Left = 120
        Top = 136
        Width = 165
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        ItemHeight = 13
        TabOrder = 5
        OnChange = DoClick
      end
    end
    object OptionsGB: TGroupBox
      Left = 8
      Top = 280
      Width = 293
      Height = 123
      Anchors = [akLeft, akTop, akRight]
      Caption = 'Options'
      TabOrder = 2
      DesignSize = (
        293
        123)
      object ShowTopLbl: TLabel
        Left = 12
        Top = 44
        Width = 59
        Height = 13
        Caption = 'TopN values'
      end
      object CaptionLbl: TLabel
        Left = 12
        Top = 68
        Width = 63
        Height = 13
        Caption = 'TopN caption'
      end
      object SortLbl: TLabel
        Left = 12
        Top = 20
        Width = 49
        Height = 13
        Caption = 'Sort order'
      end
      object XLbl: TLabel
        Left = 12
        Top = 92
        Width = 28
        Height = 13
        Caption = 'X axis'
      end
      object TopNE: TEdit
        Tag = 12
        Left = 235
        Top = 43
        Width = 33
        Height = 21
        Anchors = [akTop, akRight]
        TabOrder = 0
        Text = '0'
        OnChange = DoClick
      end
      object TopNCaptionE: TEdit
        Tag = 13
        Left = 120
        Top = 65
        Width = 165
        Height = 21
        Anchors = [akLeft, akRight]
        TabOrder = 1
        OnChange = DoClick
      end
      object SortCB: TComboBox
        Tag = 14
        Left = 120
        Top = 16
        Width = 165
        Height = 21
        Style = csDropDownList
        Anchors = [akLeft, akRight]
        ItemHeight = 13
        TabOrder = 2
        OnClick = DoClick
      end
      object UpDown1: TUpDown
        Tag = 12
        Left = 268
        Top = 43
        Width = 16
        Height = 21
        Anchors = [akTop, akRight]
        Associate = TopNE
        TabOrder = 3
        OnClick = UpDown1Click
      end
      object XTypeCB: TComboBox
        Tag = 15
        Left = 120
        Top = 90
        Width = 165
        Height = 21
        Style = csDropDownList
        Anchors = [akLeft, akRight]
        ItemHeight = 13
        TabOrder = 4
        OnChange = DoClick
      end
    end
  end
  object ChartImages: TImageList
    Left = 86
    Top = 250
  end
end
