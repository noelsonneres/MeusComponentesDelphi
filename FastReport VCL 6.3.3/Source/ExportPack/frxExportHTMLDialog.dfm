inherited frxHTMLExportDialog: TfrxHTMLExportDialog
  Tag = 8200
  Left = 19
  Top = 131
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl1: TPageControl
    inherited ExportPage: TTabSheet
      inherited GroupQuality: TGroupBox
        object PicturesL: TLabel
          Tag = 8203
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
          TabOrder = 2
        end
        object PicsSameCB: TCheckBox
          Tag = 8204
          Left = 12
          Top = 40
          Width = 129
          Height = 17
          Caption = 'All in one folder'
          Checked = True
          State = cbChecked
          TabOrder = 0
        end
        object FixWidthCB: TCheckBox
          Tag = 8205
          Left = 144
          Top = 20
          Width = 129
          Height = 17
          Caption = 'Fixed width'
          Checked = True
          State = cbChecked
          TabOrder = 3
        end
        object NavigatorCB: TCheckBox
          Tag = 8206
          Left = 12
          Top = 60
          Width = 129
          Height = 17
          Caption = 'Page navigator'
          Checked = True
          State = cbChecked
          TabOrder = 1
        end
        object MultipageCB: TCheckBox
          Tag = 8207
          Left = 144
          Top = 40
          Width = 129
          Height = 17
          Caption = 'Multipage'
          Checked = True
          State = cbChecked
          TabOrder = 4
        end
        object BackgrCB: TCheckBox
          Tag = 8209
          Left = 144
          Top = 60
          Width = 129
          Height = 17
          Caption = 'Background'
          Checked = True
          State = cbChecked
          TabOrder = 5
        end
        object PFormatCB: TComboBox
          Left = 88
          Top = 80
          Width = 173
          Height = 21
          ItemHeight = 13
          TabOrder = 6
          Text = 'JPEG'
          Items.Strings = (
            'None'
            'JPEG'
            'BMP'
            'GIF')
        end
      end
    end
  end
end
