object frxTXTExportDialog: TfrxTXTExportDialog
  Left = 252
  Top = 183
  ActiveControl = OK
  BorderStyle = bsDialog
  Caption = 'Export to text (dot-matrix printer)'
  ClientHeight = 378
  ClientWidth = 622
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = True
  Position = poScreenCenter
  Scaled = False
  ShowHint = True
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object OK: TButton
    Left = 456
    Top = 345
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 2
  end
  object Cancel: TButton
    Left = 540
    Top = 345
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 3
  end
  object Panel1: TPanel
    Left = 4
    Top = 4
    Width = 261
    Height = 333
    TabOrder = 0
    object BtnPreview: TSpeedButton
      Left = 207
      Top = 282
      Width = 32
      Height = 32
      Hint = 'Preview on/off'
      AllowAllUp = True
      GroupIndex = 2
      Flat = True
      Glyph.Data = {
        4E010000424D4E01000000000000760000002800000012000000120000000100
        040000000000D800000000000000000000001000000010000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
        7774470000007777777777777747440000007777777777777474440000007777
        7777777747444700000077770000007474447700000077007777780744477700
        00007087777777F844777700000070777777777F077777000000077777777777
        8077770000000777777777777077770000000777777777777077770000000777
        7777777770777700000007F77777777770777700000007F77777777770777700
        000070FF77777777077777000000708FFF777778077777000000770077777700
        777777000000777700000077777777000000}
      OnClick = BtnPreviewClick
    end
    object GroupCellProp: TGroupBox
      Left = 8
      Top = 108
      Width = 245
      Height = 77
      Caption = ' Export properties  '
      TabOrder = 2
      object CB_PageBreaks: TCheckBox
        Left = 12
        Top = 20
        Width = 113
        Height = 17
        Caption = 'Page breaks'
        Checked = True
        State = cbChecked
        TabOrder = 0
        OnClick = E_ScaleXChange
      end
      object CB_OEM: TCheckBox
        Left = 128
        Top = 20
        Width = 113
        Height = 17
        Caption = 'OEM codepage'
        Checked = True
        State = cbChecked
        TabOrder = 2
        OnClick = CB_OEMClick
      end
      object CB_EmptyLines: TCheckBox
        Left = 12
        Top = 44
        Width = 113
        Height = 17
        Caption = 'Empty lines'
        Checked = True
        State = cbChecked
        TabOrder = 1
        OnClick = E_ScaleXChange
      end
      object CB_LeadSpaces: TCheckBox
        Left = 128
        Top = 44
        Width = 113
        Height = 17
        Caption = 'Lead spaces'
        Checked = True
        State = cbChecked
        TabOrder = 3
        OnClick = E_ScaleXChange
      end
    end
    object GroupPageRange: TGroupBox
      Left = 8
      Top = 188
      Width = 245
      Height = 77
      Caption = ' Page range  '
      TabOrder = 3
      object Pages: TLabel
        Left = 12
        Top = 20
        Width = 68
        Height = 13
        Caption = 'Page numbers'
      end
      object Descr: TLabel
        Left = 12
        Top = 40
        Width = 229
        Height = 29
        AutoSize = False
        Caption = 
          'Enter numbers and/or page ranges, separated by commas. For examp' +
          'le: 1,3,5-12'
        WordWrap = True
      end
      object E_Range: TEdit
        Left = 92
        Top = 16
        Width = 141
        Height = 21
        TabOrder = 0
      end
    end
    object GroupScaleSettings: TGroupBox
      Left = 8
      Top = 4
      Width = 129
      Height = 101
      Caption = ' Scaling '
      TabOrder = 0
      object ScX: TLabel
        Left = 11
        Top = 28
        Width = 50
        Height = 13
        AutoSize = False
        Caption = 'Width'
      end
      object Label2: TLabel
        Left = 111
        Top = 28
        Width = 11
        Height = 13
        Caption = '%'
      end
      object ScY: TLabel
        Left = 11
        Top = 64
        Width = 46
        Height = 13
        AutoSize = False
        Caption = 'Height'
      end
      object Label9: TLabel
        Left = 111
        Top = 64
        Width = 11
        Height = 13
        Caption = '%'
      end
      object E_ScaleX: TEdit
        Left = 57
        Top = 24
        Width = 33
        Height = 21
        TabOrder = 0
        Text = '100'
      end
      object UpDown1: TUpDown
        Left = 90
        Top = 24
        Width = 17
        Height = 21
        Associate = E_ScaleX
        ArrowKeys = False
        Min = 10
        Max = 500
        Increment = 10
        ParentShowHint = False
        Position = 100
        ShowHint = False
        TabOrder = 1
        Thousands = False
        Wrap = False
        OnChanging = UpDown1Changing
      end
      object UpDown2: TUpDown
        Left = 90
        Top = 60
        Width = 17
        Height = 21
        Associate = E_ScaleY
        ArrowKeys = False
        Min = 10
        Max = 500
        Increment = 10
        ParentShowHint = False
        Position = 100
        ShowHint = False
        TabOrder = 2
        Thousands = False
        Wrap = False
        OnChanging = UpDown1Changing
      end
      object E_ScaleY: TEdit
        Left = 57
        Top = 60
        Width = 33
        Height = 21
        TabOrder = 3
        Text = '100'
      end
    end
    object GroupFramesSettings: TGroupBox
      Left = 144
      Top = 4
      Width = 109
      Height = 101
      Caption = ' Frames '
      TabOrder = 1
      object RB_NoneFrames: TRadioButton
        Tag = 1
        Left = 12
        Top = 20
        Width = 85
        Height = 17
        Caption = 'None'
        Checked = True
        TabOrder = 0
        TabStop = True
        OnClick = E_ScaleXChange
      end
      object RB_Simple: TRadioButton
        Tag = 1
        Left = 12
        Top = 44
        Width = 89
        Height = 17
        Caption = 'Simple'
        TabOrder = 1
        OnClick = E_ScaleXChange
      end
      object RB_Graph: TRadioButton
        Tag = 1
        Left = 12
        Top = 68
        Width = 89
        Height = 17
        Hint = 'Only with OEM codepage'
        Caption = 'Graphic'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        OnClick = E_ScaleXChange
      end
    end
    object CB_PrintAfter: TCheckBox
      Left = 20
      Top = 276
      Width = 157
      Height = 17
      Caption = 'Print after export'
      Checked = True
      State = cbChecked
      TabOrder = 4
    end
  end
  object Panel2: TPanel
    Left = 268
    Top = 4
    Width = 351
    Height = 333
    TabOrder = 1
    object GroupBox1: TGroupBox
      Left = 8
      Top = 4
      Width = 337
      Height = 321
      Caption = ' Preview '
      TabOrder = 0
      object Label1: TLabel
        Left = 4
        Top = 20
        Width = 49
        Height = 13
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Width:'
      end
      object Label3: TLabel
        Left = 76
        Top = 20
        Width = 49
        Height = 13
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Height:'
      end
      object PgHeight: TLabel
        Left = 128
        Top = 20
        Width = 25
        Height = 13
        AutoSize = False
        Caption = '0'
      end
      object PgWidth: TLabel
        Left = 56
        Top = 20
        Width = 25
        Height = 13
        AutoSize = False
        Caption = '0'
      end
      object LBPage: TLabel
        Left = 208
        Top = 20
        Width = 49
        Height = 13
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Page'
      end
      object ToolButton1: TSpeedButton
        Left = 160
        Top = 14
        Width = 23
        Height = 22
        Flat = True
        Glyph.Data = {
          F6000000424DF600000000000000760000002800000010000000100000000100
          0400000000008000000000000000000000001000000010000000000000000000
          80000080000000808000800000008000800080800000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
          7447777777777777474477777777777474447777777777474447777770000474
          447777700FFFF84447777708FFFFFF808777770FFF22FFF0777770FFFF22FFFF
          077770FF222222FF077770FF222222FF077770FFFF22FFFF0777770FFF22FFF0
          77777708FFFFFF80777777700FFFF00777777777700007777777}
        OnClick = ToolButton1Click
      end
      object ToolButton2: TSpeedButton
        Left = 183
        Top = 14
        Width = 23
        Height = 22
        Flat = True
        Glyph.Data = {
          F6000000424DF600000000000000760000002800000010000000100000000100
          0400000000008000000000000000000000001000000010000000000000000000
          80000080000000808000800000008000800080800000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
          7447777777777777474477777777777474447777777777474447777770000474
          447777700FFFF84447777708FFFFFF808777770FFFFFFFF0777770FFFFFFFFFF
          077770FF222222FF077770FF222222FF077770FFFFFFFFFF0777770FFFFFFFF0
          77777708FFFFFF80777777700FFFF00777777777700007777777}
        OnClick = ToolButton2Click
      end
      object Preview: TMemo
        Left = 8
        Top = 44
        Width = 321
        Height = 269
        DragCursor = crDefault
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Courier New'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        ScrollBars = ssBoth
        TabOrder = 1
        WordWrap = False
      end
      object EPage: TEdit
        Left = 264
        Top = 16
        Width = 40
        Height = 21
        TabOrder = 0
        Text = '1'
        OnChange = E_ScaleXChange
      end
      object PageUpDown: TUpDown
        Left = 304
        Top = 16
        Width = 25
        Height = 21
        Associate = EPage
        Min = 1
        Orientation = udHorizontal
        Position = 1
        TabOrder = 2
        Wrap = False
      end
    end
  end
  object SaveDialog1: TSaveDialog
    Options = [ofHideReadOnly, ofNoChangeDir, ofEnableSizing]
    Left = 56
    Top = 344
  end
end
