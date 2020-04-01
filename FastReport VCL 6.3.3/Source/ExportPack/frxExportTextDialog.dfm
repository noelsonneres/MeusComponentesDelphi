inherited frxSimpleTextExportDialog: TfrxSimpleTextExportDialog
  Tag = 8800
  Left = 32
  Top = 159
  Caption = 'Export to Text'
  ClientHeight = 325
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl1: TPageControl
    Height = 285
    inherited ExportPage: TTabSheet
      inherited OpenCB: TCheckBox
        Top = 240
      end
      inherited GroupQuality: TGroupBox
        Tag = 8302
        Height = 68
        object PageBreaksCB: TCheckBox
          Tag = 6
          Left = 12
          Top = 20
          Width = 121
          Height = 17
          Caption = 'Page breaks'
          Checked = True
          State = cbChecked
          TabOrder = 0
        end
        object FramesCB: TCheckBox
          Tag = 8312
          Left = 12
          Top = 40
          Width = 121
          Height = 17
          Caption = 'Frames'
          Checked = True
          State = cbChecked
          TabOrder = 1
        end
        object EmptyLinesCB: TCheckBox
          Tag = 8305
          Left = 136
          Top = 20
          Width = 121
          Height = 17
          Caption = 'Empty lines'
          Checked = True
          State = cbChecked
          TabOrder = 2
        end
        object OEMCB: TCheckBox
          Tag = 8304
          Left = 136
          Top = 40
          Width = 121
          Height = 17
          Caption = 'OEM codepage'
          Checked = True
          State = cbChecked
          TabOrder = 3
        end
      end
      inherited GroupBox1: TGroupBox
        Top = 200
      end
    end
  end
  inherited OkB: TButton
    Top = 295
  end
  inherited CancelB: TButton
    Top = 295
  end
end
