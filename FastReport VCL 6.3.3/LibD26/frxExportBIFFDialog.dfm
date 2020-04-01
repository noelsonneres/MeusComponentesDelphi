inherited frxBIFFExportDialog: TfrxBIFFExportDialog
  Tag = 9182
  Left = 18
  Top = 136
  Caption = 'Export to Excel 97/2000/XP'
  ClientHeight = 403
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl1: TPageControl
    Height = 359
    inherited ExportPage: TTabSheet
      inherited GroupQuality: TGroupBox
        Tag = 9157
        Left = 3
        Top = 131
        object rbOriginal: TRadioButton
          Tag = 9158
          Left = 12
          Top = 24
          Width = 206
          Height = 17
          Caption = '_Original pages'
          TabOrder = 0
        end
        object rbSingle: TRadioButton
          Tag = 9156
          Left = 12
          Top = 47
          Width = 206
          Height = 17
          Caption = '_Single page'
          TabOrder = 1
        end
        object rbChunks: TRadioButton
          Tag = 9159
          Left = 12
          Top = 70
          Width = 206
          Height = 17
          Caption = '_Chunks. Each chunk (rows):'
          TabOrder = 2
        end
        object edChunk: TEdit
          Left = 224
          Top = 68
          Width = 32
          Height = 21
          TabOrder = 3
          Text = 'edChunk'
        end
      end
      inherited GroupBox1: TGroupBox
        TabOrder = 4
      end
      object cbAutoCreateFile: TCheckBox
        Tag = 9152
        Left = 7
        Top = 306
        Width = 244
        Height = 17
        Caption = '_Auto create file'
        TabOrder = 3
      end
    end
    object tsInfo: TTabSheet
      Tag = 9174
      Caption = '-info'
      ImageIndex = 1
      object lbTitle: TLabel
        Tag = 9171
        Left = 18
        Top = 6
        Width = 22
        Height = 13
        Caption = '-title'
      end
      object lbAuthor: TLabel
        Tag = 9162
        Left = 18
        Top = 30
        Width = 36
        Height = 13
        Caption = '-author'
      end
      object lbKeywords: TLabel
        Tag = 9164
        Left = 18
        Top = 54
        Width = 50
        Height = 13
        Caption = '-keywords'
      end
      object lbRevision: TLabel
        Tag = 9165
        Left = 18
        Top = 78
        Width = 20
        Height = 13
        Caption = '-rev'
      end
      object lbAppName: TLabel
        Tag = 9167
        Left = 18
        Top = 102
        Width = 48
        Height = 13
        Caption = '-appname'
      end
      object lbSubject: TLabel
        Tag = 9168
        Left = 18
        Top = 126
        Width = 24
        Height = 13
        Caption = '-subj'
      end
      object lbCategory: TLabel
        Tag = 9169
        Left = 18
        Top = 150
        Width = 47
        Height = 13
        Caption = '-category'
      end
      object lbCompany: TLabel
        Tag = 9170
        Left = 18
        Top = 174
        Width = 47
        Height = 13
        Caption = '-company'
      end
      object lbManager: TLabel
        Tag = 9172
        Left = 18
        Top = 198
        Width = 46
        Height = 13
        Caption = '-manager'
      end
      object lbComment: TLabel
        Tag = 9163
        Left = 18
        Top = 222
        Width = 47
        Height = 13
        Caption = '-comment'
      end
      object edTitle: TEdit
        Left = 121
        Top = 3
        Width = 154
        Height = 21
        TabOrder = 0
        Text = 'edTitle'
      end
      object edAuthor: TEdit
        Left = 120
        Top = 27
        Width = 155
        Height = 21
        TabOrder = 1
        Text = 'Edit1'
      end
      object edKeywords: TEdit
        Left = 120
        Top = 51
        Width = 155
        Height = 21
        TabOrder = 2
        Text = 'Edit1'
      end
      object edRevision: TEdit
        Left = 120
        Top = 75
        Width = 155
        Height = 21
        TabOrder = 3
        Text = 'Edit1'
      end
      object edAppName: TEdit
        Left = 120
        Top = 99
        Width = 155
        Height = 21
        TabOrder = 4
        Text = 'Edit1'
      end
      object edSubject: TEdit
        Left = 120
        Top = 123
        Width = 155
        Height = 21
        TabOrder = 5
        Text = 'Edit1'
      end
      object edCategory: TEdit
        Left = 120
        Top = 147
        Width = 155
        Height = 21
        TabOrder = 6
        Text = 'Edit1'
      end
      object edCompany: TEdit
        Left = 120
        Top = 171
        Width = 155
        Height = 21
        TabOrder = 7
        Text = 'Edit1'
      end
      object edManager: TEdit
        Left = 120
        Top = 195
        Width = 155
        Height = 21
        TabOrder = 8
        Text = 'Edit1'
      end
      object edComment: TMemo
        Left = 120
        Top = 219
        Width = 155
        Height = 21
        Lines.Strings = (
          'edComment')
        TabOrder = 9
      end
    end
    object tsProt: TTabSheet
      Tag = 9175
      Caption = '-prot'
      ImageIndex = 2
      object lbPass: TLabel
        Tag = 9176
        Left = 16
        Top = 14
        Width = 50
        Height = 13
        Caption = '-password'
      end
      object lbPassInfo: TLabel
        Tag = 9177
        Left = 16
        Top = 64
        Width = 249
        Height = 161
        AutoSize = False
        Caption = 'lbPassInfo'
        WordWrap = True
      end
      object lbPassConf: TLabel
        Tag = 9178
        Left = 16
        Top = 40
        Width = 25
        Height = 13
        Caption = '-conf'
      end
      object edPass1: TEdit
        Left = 114
        Top = 11
        Width = 156
        Height = 21
        TabOrder = 0
        Text = 'edPass1'
      end
      object edPass2: TEdit
        Left = 114
        Top = 37
        Width = 156
        Height = 21
        TabOrder = 1
        Text = 'edPass'
      end
    end
    object TabSheet1: TTabSheet
      Tag = 9153
      Caption = 'Options'
      ImageIndex = 3
      object cbPreciseQuality: TCheckBox
        Tag = 8502
        Left = 15
        Top = 15
        Width = 250
        Height = 17
        Caption = '_Precise quality'
        Checked = True
        State = cbChecked
        TabOrder = 0
      end
      object cbPictures: TCheckBox
        Tag = 8002
        Left = 15
        Top = 38
        Width = 250
        Height = 17
        Caption = '-pics'
        Checked = True
        State = cbChecked
        TabOrder = 1
      end
      object cbGridLines: TCheckBox
        Tag = 9155
        Left = 15
        Top = 61
        Width = 250
        Height = 17
        Caption = '_Grid lines'
        Checked = True
        State = cbChecked
        TabOrder = 2
      end
      object cbFit: TCheckBox
        Tag = 9181
        Left = 15
        Top = 85
        Width = 250
        Height = 17
        Caption = '-fit'
        Checked = True
        State = cbChecked
        TabOrder = 3
      end
      object cbDelEmptyRows: TCheckBox
        Tag = 9183
        Left = 15
        Top = 108
        Width = 250
        Height = 17
        Caption = 'Del Rmpty Rows'
        TabOrder = 4
      end
      object cbFormulas: TCheckBox
        Tag = 9184
        Left = 15
        Top = 131
        Width = 250
        Height = 17
        Caption = 'Formulas'
        TabOrder = 5
      end
    end
  end
  inherited OkB: TButton
    Top = 371
  end
  inherited CancelB: TButton
    Top = 371
  end
end
