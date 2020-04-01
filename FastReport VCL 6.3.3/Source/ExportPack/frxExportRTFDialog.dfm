inherited frxRTFExportDialog: TfrxRTFExportDialog
  Tag = 8500
  Left = 20
  Top = 144
  Caption = 'Export to RTF'
  ClientHeight = 361
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl1: TPageControl
    Height = 317
    inherited ExportPage: TTabSheet
      inherited OpenCB: TCheckBox
        Top = 268
      end
      inherited GroupQuality: TGroupBox
        Height = 97
        object HeadFootL: TLabel
          Tag = 8951
          Left = 12
          Top = 65
          Width = 121
          Height = 13
          AutoSize = False
          Caption = 'Page headers/footers'
        end
        object WCB: TCheckBox
          Tag = 8502
          Left = 140
          Top = 20
          Width = 121
          Height = 17
          Caption = 'WYSIWYG'
          Checked = True
          State = cbChecked
          TabOrder = 0
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
          TabOrder = 1
        end
        object PicturesCB: TCheckBox
          Tag = 8501
          Left = 12
          Top = 20
          Width = 121
          Height = 17
          Caption = 'Pictures'
          Checked = True
          State = cbChecked
          TabOrder = 2
        end
        object ContinuousCB: TCheckBox
          Tag = 8950
          Left = 140
          Top = 40
          Width = 121
          Height = 17
          Caption = 'Continuous'
          Checked = True
          State = cbChecked
          TabOrder = 3
        end
        object PColontitulCB: TComboBox
          Left = 140
          Top = 62
          Width = 109
          Height = 21
          ItemHeight = 13
          TabOrder = 4
          Text = 'Text'
          Items.Strings = (
            'Text'
            'Headers/Footers'
            'None')
        end
      end
      inherited GroupBox1: TGroupBox
        Top = 228
      end
    end
  end
  inherited OkB: TButton
    Top = 327
  end
  inherited CancelB: TButton
    Top = 327
  end
end
