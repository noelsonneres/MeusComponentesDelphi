inherited frxCSVExportDialog: TfrxCSVExportDialog
  Tag = 8850
  Left = 35
  Top = 172
  Caption = 'Export to CSV'
  ClientHeight = 306
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl1: TPageControl
    Height = 269
    inherited ExportPage: TTabSheet
      inherited OpenCB: TCheckBox
        Top = 225
      end
      inherited GroupQuality: TGroupBox
        Tag = 8302
        Height = 52
        object SeparatorLB: TLabel
          Tag = 8853
          Left = 137
          Top = 21
          Width = 76
          Height = 13
          AutoSize = False
          Caption = 'Separator'
        end
        object OEMCB: TCheckBox
          Tag = 8304
          Left = 12
          Top = 20
          Width = 121
          Height = 17
          Caption = 'OEM codepage'
          Checked = True
          State = cbChecked
          TabOrder = 0
        end
        object SeparatorE: TEdit
          Left = 224
          Top = 16
          Width = 33
          Height = 21
          TabOrder = 1
        end
      end
      inherited GroupBox1: TGroupBox
        Top = 185
      end
    end
  end
  inherited OkB: TButton
    Top = 276
  end
  inherited CancelB: TButton
    Top = 276
  end
end
