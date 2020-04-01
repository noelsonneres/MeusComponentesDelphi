inherited frxODFExportDialog: TfrxODFExportDialog
  Tag = 8302
  Left = 49
  Top = 198
  ClientHeight = 318
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl1: TPageControl
    Height = 285
    inherited ExportPage: TTabSheet
      inherited OpenCB: TCheckBox
        Top = 238
      end
      inherited GroupQuality: TGroupBox
        Height = 66
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
        Top = 198
      end
    end
  end
  inherited OkB: TButton
    Top = 290
  end
  inherited CancelB: TButton
    Top = 290
  end
end
