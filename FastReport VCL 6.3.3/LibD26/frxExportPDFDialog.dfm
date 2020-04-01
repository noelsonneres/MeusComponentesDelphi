inherited frxPDFExportDialog: TfrxPDFExportDialog
  Left = 758
  Top = 291
  ClientHeight = 431
  OnKeyDown = nil
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl1: TPageControl
    Tag = 107
    Height = 388
    Anchors = [akLeft, akTop, akBottom]
    inherited ExportPage: TTabSheet
      inherited OpenCB: TCheckBox
        Top = 340
        Anchors = [akLeft, akBottom]
      end
      inherited GroupQuality: TGroupBox
        Height = 170
        Anchors = [akLeft, akBottom]
        object Label2: TLabel
          Tag = 8602
          Left = 12
          Top = 144
          Width = 121
          Height = 13
          AutoSize = False
          Caption = 'JPEG Quality'
        end
        object PDFStandardLabel: TLabel
          Tag = 8710
          Left = 12
          Top = 20
          Width = 117
          Height = 17
          AutoSize = False
          Caption = 'PDF Standard:'
        end
        object PDFVersionLabel: TLabel
          Tag = 8711
          Left = 12
          Top = 48
          Width = 117
          Height = 17
          AutoSize = False
          Caption = 'PDF Version:'
        end
        object CompressedCB: TCheckBox
          Tag = 8712
          Left = 12
          Top = 76
          Width = 117
          Height = 17
          Caption = 'Compressed'
          TabOrder = 0
        end
        object EmbeddedCB: TCheckBox
          Tag = 8702
          Left = 12
          Top = 96
          Width = 117
          Height = 17
          Caption = 'Embedded fonts'
          Checked = True
          State = cbChecked
          TabOrder = 1
        end
        object PrintOptCB: TCheckBox
          Tag = 8703
          Left = 136
          Top = 76
          Width = 117
          Height = 17
          Caption = 'Print optimized'
          TabOrder = 3
        end
        object OutlineCB: TCheckBox
          Tag = 8704
          Left = 136
          Top = 96
          Width = 117
          Height = 17
          Caption = 'Outline'
          Checked = True
          State = cbChecked
          TabOrder = 4
        end
        object BackgrCB: TCheckBox
          Tag = 8705
          Left = 12
          Top = 116
          Width = 117
          Height = 17
          Caption = 'Background'
          Checked = True
          State = cbChecked
          TabOrder = 2
        end
        object QualityEdit: TEdit
          Left = 136
          Top = 141
          Width = 53
          Height = 21
          TabOrder = 5
          Text = '100'
        end
        object TransparentCB: TCheckBox
          Tag = 8709
          Left = 136
          Top = 116
          Width = 117
          Height = 17
          Caption = 'Transparency'
          TabOrder = 6
        end
        object PDFStandardComboBox: TComboBox
          Left = 136
          Top = 17
          Width = 117
          Height = 21
          Style = csDropDownList
          DropDownCount = 15
          ItemHeight = 13
          TabOrder = 7
          OnChange = PDFStandardComboBoxChange
        end
        object PDFVersionComboBox: TComboBox
          Left = 136
          Top = 45
          Width = 117
          Height = 21
          Style = csDropDownList
          DropDownCount = 15
          ItemHeight = 13
          TabOrder = 8
        end
      end
      inherited GroupBox1: TGroupBox
        Top = 298
        Anchors = [akLeft, akBottom]
        inherited FiltersNameCB: TComboBox
          Left = 4
          Top = 14
        end
      end
    end
    object InfoPage: TTabSheet
      Tag = 8972
      Caption = 'Information'
      ImageIndex = 1
      object DocInfoGB: TGroupBox
        Tag = 8971
        Left = 4
        Top = 4
        Width = 267
        Height = 197
        Caption = 'Document information'
        TabOrder = 0
        object TitleL: TLabel
          Tag = 8973
          Left = 12
          Top = 26
          Width = 89
          Height = 16
          AutoSize = False
          Caption = 'Title'
        end
        object AuthorL: TLabel
          Tag = 8974
          Left = 12
          Top = 54
          Width = 89
          Height = 16
          AutoSize = False
          Caption = 'Author'
        end
        object SubjectL: TLabel
          Tag = 8975
          Left = 12
          Top = 82
          Width = 89
          Height = 16
          AutoSize = False
          Caption = 'Subject'
        end
        object KeywordsL: TLabel
          Tag = 8976
          Left = 12
          Top = 110
          Width = 89
          Height = 16
          AutoSize = False
          Caption = 'Keywords'
        end
        object CreatorL: TLabel
          Tag = 8977
          Left = 12
          Top = 138
          Width = 89
          Height = 16
          AutoSize = False
          Caption = 'Creator'
        end
        object ProducerL: TLabel
          Tag = 8978
          Left = 12
          Top = 166
          Width = 89
          Height = 16
          AutoSize = False
          Caption = 'Producer'
        end
        object TitleE: TEdit
          Left = 108
          Top = 22
          Width = 152
          Height = 21
          TabOrder = 0
        end
        object AuthorE: TEdit
          Left = 108
          Top = 50
          Width = 152
          Height = 21
          TabOrder = 1
        end
        object SubjectE: TEdit
          Left = 108
          Top = 78
          Width = 152
          Height = 21
          TabOrder = 2
        end
        object KeywordsE: TEdit
          Left = 108
          Top = 106
          Width = 152
          Height = 21
          TabOrder = 3
        end
        object CreatorE: TEdit
          Left = 108
          Top = 134
          Width = 152
          Height = 21
          TabOrder = 4
        end
        object ProducerE: TEdit
          Left = 108
          Top = 162
          Width = 152
          Height = 21
          TabOrder = 5
        end
      end
    end
    object SecurityPage: TTabSheet
      Tag = 8962
      Caption = 'Security'
      ImageIndex = 2
      object SecGB: TGroupBox
        Tag = 8979
        Left = 4
        Top = 4
        Width = 267
        Height = 84
        Caption = 'Authentification'
        TabOrder = 1
        object OwnPassL: TLabel
          Tag = 8964
          Left = 12
          Top = 26
          Width = 114
          Height = 16
          AutoSize = False
          Caption = 'Owner password'
        end
        object UserPassL: TLabel
          Tag = 8965
          Left = 13
          Top = 54
          Width = 113
          Height = 16
          AutoSize = False
          Caption = 'User password'
        end
        object OwnPassE: TEdit
          Left = 127
          Top = 22
          Width = 133
          Height = 21
          PasswordChar = '*'
          TabOrder = 0
        end
        object UserPassE: TEdit
          Left = 127
          Top = 50
          Width = 133
          Height = 21
          PasswordChar = '*'
          TabOrder = 1
        end
      end
      object PermGB: TGroupBox
        Tag = 8980
        Left = 4
        Top = 91
        Width = 265
        Height = 121
        Caption = 'Permissions'
        TabOrder = 0
        object PrintCB: TCheckBox
          Tag = 8966
          Left = 12
          Top = 21
          Width = 248
          Height = 17
          Caption = 'Print the document'
          Checked = True
          State = cbChecked
          TabOrder = 0
        end
        object ModCB: TCheckBox
          Tag = 8967
          Left = 12
          Top = 45
          Width = 248
          Height = 17
          Caption = 'Modify the document'
          Checked = True
          State = cbChecked
          TabOrder = 1
        end
        object CopyCB: TCheckBox
          Tag = 8968
          Left = 12
          Top = 68
          Width = 248
          Height = 17
          Caption = 'Copy of text and graphics'
          Checked = True
          State = cbChecked
          TabOrder = 2
        end
        object AnnotCB: TCheckBox
          Tag = 8969
          Left = 12
          Top = 91
          Width = 246
          Height = 17
          Caption = 'Add or modify text annotations'
          Checked = True
          State = cbChecked
          TabOrder = 3
        end
      end
    end
    object ViewerPage: TTabSheet
      Tag = 8981
      Caption = 'Viewer'
      ImageIndex = 3
      object ViewerGB: TGroupBox
        Tag = 8982
        Left = 4
        Top = 0
        Width = 267
        Height = 177
        Caption = 'Viewer preferences'
        TabOrder = 0
        object HideToolbarCB: TCheckBox
          Tag = 8983
          Left = 12
          Top = 24
          Width = 241
          Height = 17
          Caption = 'Hide toolbar'
          TabOrder = 0
        end
        object HideMenubarCB: TCheckBox
          Tag = 8984
          Left = 12
          Top = 48
          Width = 241
          Height = 17
          Caption = 'Hide menubar'
          TabOrder = 1
        end
        object HideWindowUICB: TCheckBox
          Tag = 8985
          Left = 12
          Top = 72
          Width = 241
          Height = 17
          Caption = 'Hide window user interface'
          TabOrder = 2
        end
        object FitWindowCB: TCheckBox
          Tag = 8986
          Left = 12
          Top = 96
          Width = 241
          Height = 17
          Caption = 'Fit window'
          TabOrder = 3
        end
        object CenterWindowCB: TCheckBox
          Tag = 8987
          Left = 12
          Top = 120
          Width = 241
          Height = 17
          Caption = 'Center window'
          TabOrder = 4
        end
        object PrintScalingCB: TCheckBox
          Tag = 8988
          Left = 12
          Top = 144
          Width = 241
          Height = 17
          Caption = 'Print scaling'
          TabOrder = 5
        end
      end
    end
  end
  inherited OkB: TButton
    Top = 398
  end
  inherited CancelB: TButton
    Top = 398
    Anchors = [akLeft, akBottom]
  end
end
