inherited frxXMLExportDialog: TfrxXMLExportDialog
  Tag = 8100
  Left = 11
  Top = 121
  ClientHeight = 437
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl1: TPageControl
    Height = 397
    inherited ExportPage: TTabSheet
      inherited OpenCB: TCheckBox
        Top = 350
      end
      inherited GroupQuality: TGroupBox
        Height = 73
        object WCB: TCheckBox
          Tag = 8102
          Left = 140
          Top = 20
          Width = 121
          Height = 17
          Caption = 'WYSIWYG'
          Checked = True
          State = cbChecked
          TabOrder = 0
        end
        object ContinuousCB: TCheckBox
          Tag = 8950
          Left = 12
          Top = 20
          Width = 121
          Height = 17
          Caption = 'Continuous'
          Checked = True
          State = cbChecked
          TabOrder = 1
        end
        object PageBreaksCB: TCheckBox
          Tag = 6
          Left = 12
          Top = 40
          Width = 121
          Height = 17
          Caption = 'Page breaks'
          Checked = True
          State = cbChecked
          TabOrder = 2
        end
        object BackgrCB: TCheckBox
          Tag = 8103
          Left = 140
          Top = 40
          Width = 121
          Height = 17
          Caption = 'Background'
          Checked = True
          State = cbChecked
          TabOrder = 3
        end
      end
      inherited GroupBox1: TGroupBox
        Top = 310
      end
      object SplitToSheetGB: TGroupBox
        Tag = 9001
        Left = 3
        Top = 201
        Width = 269
        Height = 110
        Caption = 'Split pages to sheets'
        TabOrder = 4
        object RPagesRB: TRadioButton
          Tag = 9003
          Left = 12
          Top = 40
          Width = 245
          Height = 17
          HelpContext = 108
          Caption = 'Use report pages'
          TabOrder = 0
        end
        object PrintOnPrevRB: TRadioButton
          Tag = 9004
          Left = 12
          Top = 60
          Width = 245
          Height = 17
          HelpContext = 118
          Caption = 'Use print on previous page'
          TabOrder = 1
        end
        object RowsCountRB: TRadioButton
          Tag = 9000
          Left = 12
          Top = 80
          Width = 173
          Height = 17
          HelpContext = 124
          Caption = 'Rows count:'
          TabOrder = 2
        end
        object ERows: TEdit
          Left = 191
          Top = 82
          Width = 61
          Height = 21
          HelpContext = 133
          TabOrder = 3
          OnChange = ERowsChange
          OnKeyPress = ERowsKeyPress
        end
        object NotSplitRB: TRadioButton
          Tag = 9002
          Left = 12
          Top = 20
          Width = 245
          Height = 17
          HelpContext = 108
          Caption = 'Don'#39't split'
          Checked = True
          TabOrder = 4
          TabStop = True
        end
      end
    end
  end
  inherited OkB: TButton
    Top = 407
  end
  inherited CancelB: TButton
    Top = 407
  end
end
