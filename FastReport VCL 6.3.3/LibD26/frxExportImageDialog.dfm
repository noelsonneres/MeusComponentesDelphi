inherited frxIMGExportDialog: TfrxIMGExportDialog
  Tag = 8600
  Left = 27
  Top = 146
  Caption = 'Export to Images'
  ClientHeight = 386
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl1: TPageControl
    Height = 343
    inherited ExportPage: TTabSheet
      inherited OpenCB: TCheckBox
        Top = 296
        Visible = False
      end
      inherited GroupQuality: TGroupBox
        Tag = 8601
        Top = 141
        object Label2: TLabel
          Tag = 8602
          Left = 16
          Top = 48
          Width = 121
          Height = 13
          AutoSize = False
          Caption = 'JPEG Quality'
        end
        object Label1: TLabel
          Tag = 8603
          Left = 16
          Top = 76
          Width = 113
          Height = 13
          AutoSize = False
          Caption = 'Resolution (dpi)'
        end
        object CropPage: TCheckBox
          Tag = 8605
          Left = 140
          Top = 20
          Width = 125
          Height = 17
          Caption = 'Crop pages'
          Checked = True
          State = cbChecked
          TabOrder = 1
        end
        object Quality: TEdit
          Left = 140
          Top = 44
          Width = 53
          Height = 21
          TabOrder = 2
          Text = '100'
        end
        object Mono: TCheckBox
          Tag = 8606
          Left = 16
          Top = 20
          Width = 121
          Height = 17
          Caption = 'Monochrome'
          TabOrder = 0
        end
        object Resolution: TEdit
          Left = 140
          Top = 72
          Width = 53
          Height = 21
          TabOrder = 3
          Text = '96'
        end
      end
      inherited GroupPageRange: TGroupBox
        Height = 135
        object SeparateCB: TCheckBox
          Tag = 8604
          Left = 16
          Top = 113
          Width = 237
          Height = 17
          Caption = 'Separate files'
          Checked = True
          State = cbChecked
          TabOrder = 4
        end
      end
      inherited GroupBox1: TGroupBox
        Top = 256
      end
    end
  end
  inherited OkB: TButton
    Top = 353
  end
  inherited CancelB: TButton
    Top = 353
  end
end
