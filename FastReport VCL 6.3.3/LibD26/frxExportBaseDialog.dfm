object frxBaseExportDialog: TfrxBaseExportDialog
  Tag = 8700
  Left = 85
  Top = 248
  BorderStyle = bsDialog
  Caption = 'Export to PDF'
  ClientHeight = 374
  ClientWidth = 292
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
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 4
    Top = 4
    Width = 285
    Height = 331
    ActivePage = ExportPage
    MultiLine = True
    TabOrder = 0
    object ExportPage: TTabSheet
      Caption = 'Export'
      object OpenCB: TCheckBox
        Tag = 8706
        Left = 7
        Top = 283
        Width = 251
        Height = 17
        Caption = 'Open after export'
        Checked = True
        State = cbChecked
        TabOrder = 0
      end
      object GroupQuality: TGroupBox
        Tag = 8
        Left = 4
        Top = 128
        Width = 267
        Height = 113
        Caption = ' Export settings '
        TabOrder = 1
      end
      object GroupPageRange: TGroupBox
        Tag = 7
        Left = 4
        Top = 4
        Width = 267
        Height = 121
        Caption = ' Page range  '
        TabOrder = 2
        object DescrL: TLabel
          Tag = 9
          Left = 12
          Top = 82
          Width = 249
          Height = 29
          AutoSize = False
          Caption = 
            'Enter page numbers and/or page ranges, separated by commas. For ' +
            'example, 1,3,5-12'
          WordWrap = True
        end
        object AllRB: TRadioButton
          Tag = 3
          Left = 12
          Top = 20
          Width = 153
          Height = 17
          HelpContext = 108
          Caption = 'All'
          Checked = True
          TabOrder = 0
          TabStop = True
        end
        object CurPageRB: TRadioButton
          Tag = 4
          Left = 12
          Top = 40
          Width = 153
          Height = 17
          HelpContext = 118
          Caption = 'Current page'
          TabOrder = 1
        end
        object PageNumbersRB: TRadioButton
          Tag = 5
          Left = 12
          Top = 60
          Width = 77
          Height = 17
          HelpContext = 124
          Caption = 'Pages:'
          TabOrder = 2
        end
        object PageNumbersE: TEdit
          Left = 92
          Top = 58
          Width = 165
          Height = 21
          HelpContext = 133
          TabOrder = 3
          OnChange = PageNumbersEChange
          OnKeyPress = PageNumbersEKeyPress
        end
      end
      object GroupBox1: TGroupBox
        Tag = 162
        Left = 4
        Top = 243
        Width = 267
        Height = 41
        Caption = 'Save To'
        TabOrder = 3
        object FiltersNameCB: TComboBox
          Left = 3
          Top = 13
          Width = 258
          Height = 21
          ItemHeight = 13
          TabOrder = 0
          Text = 'FiltersNameCB'
        end
      end
    end
  end
  object OkB: TButton
    Tag = 1
    Left = 129
    Top = 341
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
    OnClick = OkBClick
  end
  object CancelB: TButton
    Tag = 2
    Left = 209
    Top = 341
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
end
