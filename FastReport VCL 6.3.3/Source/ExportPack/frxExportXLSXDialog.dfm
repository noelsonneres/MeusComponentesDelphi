inherited frxXLSXExportDialog: TfrxXLSXExportDialog
  Tag = 9200
  Left = 467
  Top = 314
  ClientHeight = 425
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl1: TPageControl
    Height = 389
    inherited ExportPage: TTabSheet
      inherited OpenCB: TCheckBox
        Top = 347
      end
      inherited GroupQuality: TGroupBox
        Tag = 9153
        Height = 73
        object ContinuousCB: TCheckBox
          Tag = 8950
          Left = 12
          Top = 20
          Width = 125
          Height = 17
          Caption = 'Continuous'
          Checked = True
          State = cbChecked
          TabOrder = 0
        end
        object PageBreaksCB: TCheckBox
          Tag = 6
          Left = 12
          Top = 44
          Width = 125
          Height = 17
          Caption = 'Page breaks'
          Checked = True
          State = cbChecked
          TabOrder = 1
        end
        object WCB: TCheckBox
          Tag = 8102
          Left = 136
          Top = 20
          Width = 125
          Height = 17
          Caption = 'WYSIWYG'
          Checked = True
          State = cbChecked
          TabOrder = 2
        end
        object DataOnlyCB: TCheckBox
          Tag = 9185
          Left = 136
          Top = 44
          Width = 97
          Height = 17
          Caption = 'Data only'
          TabOrder = 3
        end
      end
      inherited GroupBox1: TGroupBox
        Top = 307
      end
      object SplitToSheetGB: TGroupBox
        Tag = 9001
        Left = 4
        Top = 206
        Width = 267
        Height = 97
        Caption = 'Split pages to sheets'
        TabOrder = 4
        object RPagesRB: TRadioButton
          Tag = 9003
          Left = 12
          Top = 44
          Width = 245
          Height = 17
          Caption = 'Use report pages'
          TabOrder = 0
        end
        object NotSplitRB: TRadioButton
          Tag = 9002
          Left = 12
          Top = 23
          Width = 245
          Height = 17
          Caption = 'Don'#39't split'
          TabOrder = 1
        end
        object RowsCountRB: TRadioButton
          Tag = 9000
          Left = 12
          Top = 66
          Width = 181
          Height = 17
          Caption = 'Rows count:'
          TabOrder = 2
        end
        object edChunk: TEdit
          Left = 199
          Top = 64
          Width = 57
          Height = 21
          TabOrder = 3
          Text = 'edChunk'
        end
      end
    end
  end
  inherited OkB: TButton
    Top = 395
  end
  inherited CancelB: TButton
    Top = 395
  end
end
