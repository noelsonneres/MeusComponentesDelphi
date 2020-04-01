inherited frxXLSExportDialog: TfrxXLSExportDialog
  Tag = 8000
  Left = 1144
  Top = 211
  Caption = 'Export to Excel'
  ClientHeight = 373
  ClientWidth = 293
  Scaled = False
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl1: TPageControl
    Height = 333
    inherited ExportPage: TTabSheet
      inherited OpenCB: TCheckBox
        Left = 15
        Top = 275
      end
      inherited GroupQuality: TGroupBox
        Height = 137
        object PicturesCB: TCheckBox
          Tag = 8002
          Left = 12
          Top = 16
          Width = 121
          Height = 17
          Caption = 'Pictures'
          Checked = True
          State = cbChecked
          TabOrder = 0
        end
        object WCB: TCheckBox
          Tag = 8005
          Left = 138
          Top = 16
          Width = 121
          Height = 17
          Caption = 'WYSIWYG'
          Checked = True
          State = cbChecked
          TabOrder = 1
        end
        object PageBreaksCB: TCheckBox
          Tag = 6
          Left = 138
          Top = 88
          Width = 121
          Height = 17
          Caption = 'Page breaks'
          Checked = True
          State = cbChecked
          TabOrder = 2
        end
        object MergeCB: TCheckBox
          Tag = 8003
          Left = 138
          Top = 64
          Width = 121
          Height = 17
          Caption = 'Merge cells'
          Checked = True
          State = cbChecked
          TabOrder = 3
        end
        object FastExpCB: TCheckBox
          Tag = 8004
          Left = 12
          Top = 112
          Width = 121
          Height = 17
          Caption = 'Fast export'
          TabOrder = 4
        end
        object ContinuousCB: TCheckBox
          Tag = 8950
          Left = 12
          Top = 40
          Width = 121
          Height = 17
          Caption = 'Continuous'
          Checked = True
          State = cbChecked
          TabOrder = 5
        end
        object cbGrid: TCheckBox
          Tag = 9155
          Left = 12
          Top = 64
          Width = 121
          Height = 17
          Caption = 'Gridlines'
          TabOrder = 6
        end
        object BackgrCB: TCheckBox
          Tag = 8007
          Left = 138
          Top = 40
          Width = 121
          Height = 17
          Caption = 'Background'
          Checked = True
          State = cbChecked
          TabOrder = 7
        end
        object AsTextCB: TCheckBox
          Tag = 8006
          Left = 12
          Top = 88
          Width = 121
          Height = 17
          Caption = 'As Text'
          Checked = True
          State = cbChecked
          TabOrder = 8
        end
      end
      inherited GroupBox1: TGroupBox
        Top = 267
        Visible = False
        inherited FiltersNameCB: TComboBox
          Visible = False
        end
      end
    end
  end
end
