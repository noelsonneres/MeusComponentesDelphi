object frxAPDFExportDialog: TfrxAPDFExportDialog
  Left = 790
  Top = 118
  BorderStyle = bsDialog
  Caption = 'Export to PDF'
  ClientHeight = 368
  ClientWidth = 293
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 4
    Top = 4
    Width = 285
    Height = 325
    ActivePage = ExportPage
    MultiLine = True
    TabOrder = 0
    object ExportPage: TTabSheet
      Caption = 'Export'
      object OpenCB: TCheckBox
        Left = 4
        Top = 267
        Width = 253
        Height = 17
        Caption = 'Open after export'
        Checked = True
        State = cbChecked
        TabOrder = 0
      end
      object GroupQuality: TGroupBox
        Left = 4
        Top = 128
        Width = 267
        Height = 129
        Caption = ' Export settings '
        TabOrder = 1
        object Label2: TLabel
          Left = 13
          Top = 80
          Width = 121
          Height = 13
          AutoSize = False
          Caption = 'JPEG Quality'
        end
        object CompressedCB: TCheckBox
          Left = 12
          Top = 20
          Width = 117
          Height = 17
          Caption = 'Compressed'
          Checked = True
          State = cbChecked
          TabOrder = 0
        end
        object EmbeddedCB: TCheckBox
          Left = 12
          Top = 40
          Width = 117
          Height = 17
          Caption = 'Embedded fonts'
          Checked = True
          State = cbChecked
          TabOrder = 1
        end
        object PrintOptCB: TCheckBox
          Left = 136
          Top = 20
          Width = 126
          Height = 17
          Caption = 'Print optimized'
          TabOrder = 3
        end
        object OutlineCB: TCheckBox
          Left = 136
          Top = 40
          Width = 121
          Height = 17
          Caption = 'Outline'
          Checked = True
          State = cbChecked
          TabOrder = 4
        end
        object BackgrCB: TCheckBox
          Left = 12
          Top = 60
          Width = 117
          Height = 17
          Caption = 'Background'
          Checked = True
          State = cbChecked
          TabOrder = 2
        end
        object Quality: TEdit
          Left = 135
          Top = 76
          Width = 53
          Height = 21
          TabOrder = 5
          Text = '100'
        end
        object cbPDFA: TCheckBox
          Left = 13
          Top = 99
          Width = 97
          Height = 17
          Caption = 'PDF-A'
          TabOrder = 6
        end
      end
      object GroupPageRange: TGroupBox
        Left = 4
        Top = 4
        Width = 267
        Height = 121
        Caption = ' Page range  '
        TabOrder = 2
        object DescrL: TLabel
          Left = 12
          Top = 82
          Width = 249
          Height = 29
          AutoSize = False
          Caption = 
            'Enter page numbers and/or page ranges, separated by commas. For ' +
            'example, 1,3,5-12'
          WordWrap = True
        end
        object AllRB: TRadioButton
          Left = 12
          Top = 20
          Width = 153
          Height = 17
          HelpContext = 108
          Caption = 'All'
          Checked = True
          TabOrder = 0
          TabStop = True
        end
        object CurPageRB: TRadioButton
          Left = 12
          Top = 40
          Width = 153
          Height = 17
          HelpContext = 118
          Caption = 'Current page'
          TabOrder = 1
        end
        object PageNumbersRB: TRadioButton
          Left = 12
          Top = 60
          Width = 77
          Height = 17
          HelpContext = 124
          Caption = 'Pages:'
          TabOrder = 2
        end
        object PageNumbersE: TEdit
          Left = 92
          Top = 58
          Width = 165
          Height = 21
          HelpContext = 133
          TabOrder = 3
          OnChange = PageNumbersEChange
          OnKeyPress = PageNumbersEKeyPress
        end
      end
    end
    object InfoPage: TTabSheet
      Caption = 'Information'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 273
      object DocInfoGB: TGroupBox
        Left = 4
        Top = 4
        Width = 267
        Height = 197
        Caption = 'Document information'
        TabOrder = 0
        object TitleL: TLabel
          Left = 12
          Top = 26
          Width = 89
          Height = 16
          AutoSize = False
          Caption = 'Title'
        end
        object AuthorL: TLabel
          Left = 12
          Top = 54
          Width = 89
          Height = 16
          AutoSize = False
          Caption = 'Author'
        end
        object SubjectL: TLabel
          Left = 12
          Top = 82
          Width = 89
          Height = 16
          AutoSize = False
          Caption = 'Subject'
        end
        object KeywordsL: TLabel
          Left = 12
          Top = 110
          Width = 89
          Height = 16
          AutoSize = False
          Caption = 'Keywords'
        end
        object CreatorL: TLabel
          Left = 12
          Top = 138
          Width = 89
          Height = 16
          AutoSize = False
          Caption = 'Creator'
        end
        object ProducerL: TLabel
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
      Caption = 'Security'
      ImageIndex = 2
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 273
      object SecGB: TGroupBox
        Left = 4
        Top = 4
        Width = 267
        Height = 84
        Caption = 'Authentification'
        TabOrder = 0
        object OwnPassL: TLabel
          Left = 12
          Top = 26
          Width = 114
          Height = 16
          AutoSize = False
          Caption = 'Owner password'
        end
        object UserPassL: TLabel
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
        Left = 4
        Top = 92
        Width = 265
        Height = 121
        Caption = 'Permissions'
        TabOrder = 1
        object PrintCB: TCheckBox
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
      Caption = 'Viewer'
      ImageIndex = 3
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 273
      object ViewerGB: TGroupBox
        Left = 4
        Top = 4
        Width = 267
        Height = 177
        Caption = 'Viewer preferences'
        TabOrder = 0
        object HideToolbarCB: TCheckBox
          Left = 12
          Top = 24
          Width = 241
          Height = 17
          Caption = 'Hide toolbar'
          TabOrder = 0
        end
        object HideMenubarCB: TCheckBox
          Left = 12
          Top = 48
          Width = 241
          Height = 17
          Caption = 'Hide menubar'
          TabOrder = 1
        end
        object HideWindowUICB: TCheckBox
          Left = 12
          Top = 72
          Width = 241
          Height = 17
          Caption = 'Hide window user interface'
          TabOrder = 2
        end
        object FitWindowCB: TCheckBox
          Left = 12
          Top = 96
          Width = 241
          Height = 17
          Caption = 'Fit window'
          TabOrder = 3
        end
        object CenterWindowCB: TCheckBox
          Left = 12
          Top = 120
          Width = 241
          Height = 17
          Caption = 'Center window'
          TabOrder = 4
        end
        object PrintScalingCB: TCheckBox
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
  object OkB: TButton
    Left = 129
    Top = 335
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object CancelB: TButton
    Left = 210
    Top = 335
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object SaveDialog1: TSaveDialog
    Options = [ofHideReadOnly, ofNoChangeDir, ofEnableSizing]
    Left = 248
    Top = 32
  end
end
