inherited frxHTMLDIVExportDialog: TfrxHTMLDIVExportDialog
  Tag = 9305
  Left = 15
  Top = 126
  ActiveControl = OkB
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl1: TPageControl
    inherited ExportPage: TTabSheet
      inherited GroupQuality: TGroupBox
        object PicturesL: TLabel
          Left = 12
          Top = 84
          Width = 73
          Height = 13
          AutoSize = False
          Caption = 'Pictures'
        end
        object StylesCB: TCheckBox
          Tag = 8202
          Left = 12
          Top = 20
          Width = 129
          Height = 17
          Caption = 'Styles'
          Checked = True
          State = cbChecked
          TabOrder = 1
        end
        object UnifiedPicturesCB: TCheckBox
          Tag = 9512
          Left = 12
          Top = 40
          Width = 129
          Height = 17
          Caption = 'Unified Pictures'
          Checked = True
          State = cbChecked
          TabOrder = 0
        end
        object PicturesCB: TCheckBox
          Tag = 8002
          Left = 144
          Top = 20
          Width = 129
          Height = 17
          Caption = 'Pictures'
          Checked = True
          State = cbChecked
          TabOrder = 2
        end
        object MultipageCB: TCheckBox
          Tag = 8207
          Left = 144
          Top = 40
          Width = 129
          Height = 17
          Caption = 'Multipage'
          TabOrder = 3
        end
        object PFormatCB: TComboBox
          Left = 91
          Top = 82
          Width = 168
          Height = 21
          ItemHeight = 13
          ItemIndex = 0
          TabOrder = 4
          Text = 'PNG'
          Items.Strings = (
            'PNG'
            'EMF'
            'BMP'
            'JPEG')
        end
        object FormattedCB: TCheckBox
          Tag = 9513
          Left = 12
          Top = 60
          Width = 129
          Height = 17
          Caption = 'Formatted'
          TabOrder = 5
        end
        object NavigationCB: TCheckBox
          Tag = 8206
          Left = 144
          Top = 60
          Width = 129
          Height = 17
          Caption = 'Navigator'
          TabOrder = 6
        end
      end
    end
  end
end
