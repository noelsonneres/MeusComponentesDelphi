object frxConnectionWizardForm: TfrxConnectionWizardForm
  Left = 192
  Top = 114
  BorderStyle = bsDialog
  Caption = 'Connection Wizard'
  ClientHeight = 307
  ClientWidth = 301
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  ShowHint = True
  OnCreate = FormCreate
  OnHide = FormHide
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object OKB: TButton
    Left = 140
    Top = 276
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
    OnClick = OKBClick
  end
  object CancelB: TButton
    Left = 220
    Top = 276
    Width = 75
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object PageControl1: TPageControl
    Left = 4
    Top = 4
    Width = 293
    Height = 265
    ActivePage = ConnTS
    TabOrder = 2
    object ConnTS: TTabSheet
      Caption = 'Connection'
      object ConnL1: TLabel
        Left = 4
        Top = 4
        Width = 139
        Height = 13
        Caption = 'Choose the connection type:'
      end
      object DBL: TLabel
        Left = 4
        Top = 60
        Width = 107
        Height = 13
        Caption = 'Choose the database:'
      end
      object LoginL: TLabel
        Left = 20
        Top = 164
        Width = 25
        Height = 13
        Caption = 'Login'
      end
      object PasswordL: TLabel
        Left = 20
        Top = 188
        Width = 46
        Height = 13
        Caption = 'Password'
      end
      object ChooseB: TSpeedButton
        Left = 256
        Top = 80
        Width = 23
        Height = 22
        Caption = '...'
        OnClick = ChooseBClick
      end
      object ConnCB: TComboBox
        Left = 16
        Top = 24
        Width = 157
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 0
        OnClick = ConnCBClick
      end
      object DatabaseE: TEdit
        Left = 16
        Top = 80
        Width = 237
        Height = 21
        TabOrder = 1
      end
      object LoginE: TEdit
        Left = 116
        Top = 160
        Width = 121
        Height = 21
        TabOrder = 2
      end
      object PasswordE: TEdit
        Left = 116
        Top = 184
        Width = 121
        Height = 21
        TabOrder = 3
      end
      object PromptRB: TRadioButton
        Left = 4
        Top = 116
        Width = 193
        Height = 17
        Caption = 'Prompt login'
        Checked = True
        TabOrder = 4
        TabStop = True
      end
      object LoginRB: TRadioButton
        Left = 4
        Top = 136
        Width = 193
        Height = 17
        Caption = 'Use login/password:'
        TabOrder = 5
      end
    end
    object TableTS: TTabSheet
      Caption = 'Table'
      ImageIndex = 1
      object ConnL2: TLabel
        Left = 4
        Top = 4
        Width = 139
        Height = 13
        Caption = 'Choose the connection type:'
      end
      object TableL: TLabel
        Left = 4
        Top = 60
        Width = 115
        Height = 13
        Caption = 'Choose the table name:'
      end
      object ConnCB1: TComboBox
        Left = 16
        Top = 24
        Width = 157
        Height = 21
        Style = csDropDownList
        ItemHeight = 0
        TabOrder = 0
        OnClick = ConnCB1Click
      end
      object TableCB: TComboBox
        Left = 16
        Top = 80
        Width = 157
        Height = 21
        Style = csDropDownList
        ItemHeight = 0
        TabOrder = 1
      end
      object FilterCB: TCheckBox
        Left = 4
        Top = 116
        Width = 225
        Height = 17
        Caption = 'Filter records:'
        TabOrder = 2
      end
      object FilterE: TEdit
        Left = 16
        Top = 140
        Width = 157
        Height = 21
        TabOrder = 3
      end
    end
    object QueryTS: TTabSheet
      Caption = 'Query'
      ImageIndex = 2
      object ConnL3: TLabel
        Left = 4
        Top = 4
        Width = 139
        Height = 13
        Caption = 'Choose the connection type:'
      end
      object QueryL: TLabel
        Left = 4
        Top = 60
        Width = 75
        Height = 13
        Caption = 'SQL statement:'
      end
      object ConnCB2: TComboBox
        Left = 16
        Top = 24
        Width = 157
        Height = 21
        Style = csDropDownList
        ItemHeight = 0
        TabOrder = 0
        OnClick = ConnCB2Click
      end
      object ToolBar1: TToolBar
        Left = 232
        Top = 48
        Width = 53
        Height = 29
        Align = alNone
        EdgeBorders = []
        Flat = True
        TabOrder = 1
        object BuildSQLB: TToolButton
          Left = 0
          Top = 0
          Hint = 'Query Builder'
          ImageIndex = 58
          OnClick = BuildSQLBClick
        end
        object ParamsB: TToolButton
          Left = 23
          Top = 0
          Hint = 'Edit Query Parameters'
          ImageIndex = 71
          OnClick = ParamsBClick
        end
      end
    end
  end
end
