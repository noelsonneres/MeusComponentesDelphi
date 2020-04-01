object frxReportEditorForm: TfrxReportEditorForm
  Left = 425
  Top = 199
  BorderStyle = bsDialog
  Caption = 'Report settings'
  ClientHeight = 371
  ClientWidth = 414
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnHide = FormHide
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object OkB: TButton
    Left = 254
    Top = 340
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object CancelB: TButton
    Left = 334
    Top = 340
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object PageControl: TPageControl
    Left = 4
    Top = 4
    Width = 405
    Height = 325
    ActivePage = GeneralTS
    TabOrder = 2
    OnChange = PageControlChange
    object GeneralTS: TTabSheet
      Caption = 'General'
      object ReportSettingsL: TGroupBox
        Left = 4
        Top = 4
        Width = 389
        Height = 193
        Caption = 'Printer settings'
        TabOrder = 0
        object CopiesL: TLabel
          Left = 16
          Top = 164
          Width = 32
          Height = 13
          Caption = 'Copies'
        end
        object PrintersLB: TListBox
          Left = 12
          Top = 18
          Width = 365
          Height = 135
          Style = lbOwnerDrawFixed
          ItemHeight = 16
          TabOrder = 0
          OnDrawItem = PrintersLBDrawItem
        end
        object CopiesE: TEdit
          Left = 68
          Top = 160
          Width = 37
          Height = 21
          AutoSize = False
          Ctl3D = True
          ParentCtl3D = False
          TabOrder = 1
          Text = '1'
        end
        object CollateCB: TCheckBox
          Left = 116
          Top = 162
          Width = 189
          Height = 17
          Caption = 'Collate copies'
          TabOrder = 2
        end
      end
      object GeneralL: TGroupBox
        Left = 4
        Top = 200
        Width = 389
        Height = 93
        Caption = 'General'
        TabOrder = 1
        object PasswordL: TLabel
          Left = 184
          Top = 21
          Width = 46
          Height = 13
          Caption = 'Password'
        end
        object DoublePassCB: TCheckBox
          Left = 8
          Top = 20
          Width = 169
          Height = 17
          Caption = 'Double pass'
          TabOrder = 0
        end
        object PrintIfEmptyCB: TCheckBox
          Left = 8
          Top = 44
          Width = 169
          Height = 17
          Caption = 'Print if empty'
          TabOrder = 1
        end
        object PasswordE: TEdit
          Left = 268
          Top = 16
          Width = 109
          Height = 21
          PasswordChar = '*'
          TabOrder = 2
        end
      end
    end
    object InheritTS: TTabSheet
      Caption = 'Inheritance'
      ImageIndex = 2
      object InheritGB: TGroupBox
        Left = 4
        Top = 4
        Width = 389
        Height = 289
        Caption = 'Inheritance settings'
        TabOrder = 0
        object InheritStateL: TLabel
          Left = 8
          Top = 20
          Width = 63
          Height = 13
          Caption = 'InheritStateL'
        end
        object SelectL: TLabel
          Left = 8
          Top = 44
          Width = 85
          Height = 13
          Caption = 'Select the option:'
        end
        object PathLB: TLabel
          Left = 12
          Top = 260
          Width = 81
          Height = 13
          Caption = 'Templates path :'
        end
        object DetachRB: TRadioButton
          Left = 8
          Top = 84
          Width = 205
          Height = 17
          Caption = 'Detach the base report'
          TabOrder = 0
        end
        object InheritRB: TRadioButton
          Left = 8
          Top = 104
          Width = 205
          Height = 17
          Caption = 'Inherit from base report:'
          TabOrder = 1
        end
        object DontChangeRB: TRadioButton
          Left = 8
          Top = 64
          Width = 205
          Height = 17
          Caption = 'Don'#39't change'
          Checked = True
          TabOrder = 2
          TabStop = True
        end
        object InheritLV: TListView
          Left = 12
          Top = 128
          Width = 365
          Height = 125
          Columns = <>
          TabOrder = 3
        end
        object PathE: TEdit
          Left = 96
          Top = 256
          Width = 257
          Height = 21
          TabOrder = 4
          OnKeyPress = PathEKeyPress
        end
        object BrowseB: TButton
          Left = 352
          Top = 256
          Width = 25
          Height = 22
          Caption = '...'
          TabOrder = 5
          OnClick = BrowseBClick
        end
      end
    end
    object DescriptionTS: TTabSheet
      Caption = 'Description'
      ImageIndex = 1
      object DescriptionL: TGroupBox
        Left = 4
        Top = 4
        Width = 389
        Height = 213
        Caption = 'Description'
        TabOrder = 0
        object Bevel3: TBevel
          Left = 80
          Top = 120
          Width = 93
          Height = 77
        end
        object NameL: TLabel
          Left = 8
          Top = 20
          Width = 27
          Height = 13
          Caption = 'Name'
        end
        object PictureImg: TImage
          Left = 84
          Top = 124
          Width = 85
          Height = 69
          Center = True
        end
        object Description1L: TLabel
          Left = 8
          Top = 68
          Width = 53
          Height = 13
          Caption = 'Description'
        end
        object PictureL: TLabel
          Left = 8
          Top = 120
          Width = 33
          Height = 13
          Caption = 'Picture'
        end
        object AuthorL: TLabel
          Left = 8
          Top = 44
          Width = 33
          Height = 13
          Caption = 'Author'
        end
        object NameE: TEdit
          Left = 80
          Top = 18
          Width = 297
          Height = 21
          AutoSize = False
          Ctl3D = True
          ParentCtl3D = False
          TabOrder = 0
        end
        object DescriptionE: TMemo
          Left = 80
          Top = 66
          Width = 297
          Height = 47
          Ctl3D = True
          ParentCtl3D = False
          TabOrder = 2
        end
        object PictureB: TButton
          Left = 180
          Top = 120
          Width = 75
          Height = 21
          Caption = 'Browse...'
          TabOrder = 3
          OnClick = PictureBClick
        end
        object AuthorE: TEdit
          Left = 80
          Top = 42
          Width = 297
          Height = 21
          AutoSize = False
          Ctl3D = True
          ParentCtl3D = False
          TabOrder = 1
        end
      end
      object VersionL: TGroupBox
        Left = 4
        Top = 220
        Width = 389
        Height = 73
        Caption = 'Version'
        TabOrder = 1
        object MajorL: TLabel
          Left = 8
          Top = 22
          Width = 27
          Height = 13
          Caption = 'Major'
        end
        object MinorL: TLabel
          Left = 100
          Top = 22
          Width = 26
          Height = 13
          Caption = 'Minor'
        end
        object ReleaseL: TLabel
          Left = 196
          Top = 22
          Width = 38
          Height = 13
          Caption = 'Release'
        end
        object BuildL: TLabel
          Left = 300
          Top = 22
          Width = 22
          Height = 13
          Caption = 'Build'
        end
        object CreatedL: TLabel
          Left = 8
          Top = 46
          Width = 39
          Height = 13
          Caption = 'Created'
        end
        object Created1L: TLabel
          Left = 76
          Top = 46
          Width = 103
          Height = 13
          Caption = '22.22.2000 12:23:10'
        end
        object ModifiedL: TLabel
          Left = 212
          Top = 46
          Width = 40
          Height = 13
          Caption = 'Modified'
        end
        object Modified1L: TLabel
          Left = 276
          Top = 46
          Width = 103
          Height = 13
          Caption = '22.22.2000 12:23:10'
        end
        object MajorE: TEdit
          Left = 52
          Top = 18
          Width = 37
          Height = 21
          TabOrder = 0
        end
        object MinorE: TEdit
          Left = 144
          Top = 18
          Width = 37
          Height = 21
          TabOrder = 1
        end
        object ReleaseE: TEdit
          Left = 252
          Top = 18
          Width = 37
          Height = 21
          TabOrder = 2
        end
        object BuildE: TEdit
          Left = 340
          Top = 18
          Width = 37
          Height = 21
          TabOrder = 3
        end
      end
    end
  end
end
