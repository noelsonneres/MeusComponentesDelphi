object frxHyperlinkEditorForm: TfrxHyperlinkEditorForm
  Left = 191
  Top = 116
  BorderStyle = bsDialog
  Caption = 'Hyperlink Editor'
  ClientHeight = 382
  ClientWidth = 655
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnHide = FormHide
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object OKB: TButton
    Left = 488
    Top = 348
    Width = 75
    Height = 25
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 0
  end
  object CancelB: TButton
    Left = 572
    Top = 348
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object KindGB: TGroupBox
    Left = 8
    Top = 8
    Width = 217
    Height = 325
    Caption = 'Hyperlink kind'
    TabOrder = 2
    object UrlRB: TRadioButton
      Left = 8
      Top = 20
      Width = 200
      Height = 17
      Caption = 'URL'
      Checked = True
      TabOrder = 0
      TabStop = True
      OnClick = UrlRBClick
    end
    object PageNumberRB: TRadioButton
      Left = 8
      Top = 40
      Width = 200
      Height = 17
      Caption = 'Page number'
      TabOrder = 1
      OnClick = UrlRBClick
    end
    object AnchorRB: TRadioButton
      Left = 8
      Top = 60
      Width = 200
      Height = 17
      Caption = 'Anchor'
      TabOrder = 2
      OnClick = UrlRBClick
    end
    object ReportRB: TRadioButton
      Left = 8
      Top = 80
      Width = 200
      Height = 17
      Caption = 'Report'
      TabOrder = 3
      OnClick = UrlRBClick
    end
    object ReportPageRB: TRadioButton
      Left = 8
      Top = 100
      Width = 200
      Height = 17
      Caption = 'Report page'
      TabOrder = 4
      OnClick = UrlRBClick
    end
    object CustomRB: TRadioButton
      Left = 8
      Top = 120
      Width = 200
      Height = 17
      Caption = 'Custom'
      TabOrder = 5
      OnClick = UrlRBClick
    end
  end
  object PropertiesGB: TGroupBox
    Left = 232
    Top = 8
    Width = 417
    Height = 325
    Caption = 'Properties'
    TabOrder = 3
    object Hint1L: TLabel
      Left = 12
      Top = 256
      Width = 393
      Height = 30
      AutoSize = False
      Caption = 
        'What will happen when you click this object in the preview windo' +
        'w:'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      WordWrap = True
    end
    object Hint2L: TLabel
      Left = 12
      Top = 286
      Width = 393
      Height = 30
      AutoSize = False
      Caption = 'Hint'
      WordWrap = True
    end
    object UrlP: TPanel
      Left = 348
      Top = 16
      Width = 393
      Height = 105
      BevelOuter = bvNone
      TabOrder = 0
      object UrlL: TLabel
        Left = 0
        Top = 0
        Width = 229
        Height = 13
        Caption = 'Specify an URL (example: http://www.url.com):'
      end
      object UrlExprL: TLabel
        Left = 0
        Top = 56
        Width = 215
        Height = 13
        Caption = 'or enter the expression that returns an URL:'
      end
      object UrlE: TEdit
        Left = 0
        Top = 20
        Width = 393
        Height = 21
        TabOrder = 0
      end
      object UrlExprE: TfrxComboEdit
        Left = 0
        Top = 76
        Width = 393
        Height = 21
        Style = csSimple
        ItemHeight = 13
        TabOrder = 1
        OnButtonClick = ExprClick
      end
    end
    object PageNumberP: TPanel
      Left = 328
      Top = 40
      Width = 393
      Height = 105
      BevelOuter = bvNone
      TabOrder = 1
      object PageNumberL: TLabel
        Left = 0
        Top = 0
        Width = 105
        Height = 13
        Caption = 'Specify page number:'
      end
      object PageNumberExprL: TLabel
        Left = 0
        Top = 56
        Width = 253
        Height = 13
        Caption = 'or enter the expression that returns a page number:'
      end
      object PageNumberE: TEdit
        Left = 0
        Top = 20
        Width = 393
        Height = 21
        TabOrder = 0
      end
      object PageNumberExprE: TfrxComboEdit
        Left = 0
        Top = 76
        Width = 393
        Height = 21
        Style = csSimple
        ItemHeight = 13
        TabOrder = 1
        OnButtonClick = ExprClick
      end
    end
    object AnchorP: TPanel
      Left = 312
      Top = 64
      Width = 393
      Height = 105
      BevelOuter = bvNone
      TabOrder = 2
      object AnchorL: TLabel
        Left = 0
        Top = 0
        Width = 119
        Height = 13
        Caption = 'Specify an anchor name:'
      end
      object AnchorExprL: TLabel
        Left = 0
        Top = 56
        Width = 258
        Height = 13
        Caption = 'or enter the expression that returns an anchor name:'
      end
      object AnchorE: TEdit
        Left = 0
        Top = 20
        Width = 393
        Height = 21
        TabOrder = 0
      end
      object AnchorExprE: TfrxComboEdit
        Left = 0
        Top = 76
        Width = 393
        Height = 21
        Style = csSimple
        ItemHeight = 13
        TabOrder = 1
        OnButtonClick = ExprClick
      end
    end
    object CustomP: TPanel
      Left = 296
      Top = 88
      Width = 393
      Height = 105
      BevelOuter = bvNone
      TabOrder = 3
      object CustomL: TLabel
        Left = 0
        Top = 0
        Width = 127
        Height = 13
        Caption = 'Specify a hyperlink value::'
      end
      object CustomExprL: TLabel
        Left = 0
        Top = 56
        Width = 262
        Height = 13
        Caption = 'or enter the expression that returns a hyperlink value:'
      end
      object CustomE: TEdit
        Left = 0
        Top = 20
        Width = 393
        Height = 21
        TabOrder = 0
      end
      object CustomExprE: TfrxComboEdit
        Left = 0
        Top = 76
        Width = 393
        Height = 21
        Style = csSimple
        ItemHeight = 13
        TabOrder = 1
        OnButtonClick = ExprClick
      end
    end
    object ReportP: TPanel
      Left = 276
      Top = 116
      Width = 393
      Height = 221
      BevelOuter = bvNone
      TabOrder = 4
      object ReportValueL: TLabel
        Left = 0
        Top = 112
        Width = 130
        Height = 13
        Caption = 'Specify a parameter value:'
      end
      object ReportExprL: TLabel
        Left = 0
        Top = 168
        Width = 269
        Height = 13
        Caption = 'or enter the expression that returns a parameter value:'
      end
      object ReportNameL: TLabel
        Left = 0
        Top = 0
        Width = 66
        Height = 13
        Caption = 'Report name:'
      end
      object ReportParamL: TLabel
        Left = 0
        Top = 56
        Width = 90
        Height = 13
        Caption = 'Report parameter:'
      end
      object ReportValueE: TEdit
        Left = 0
        Top = 132
        Width = 393
        Height = 21
        TabOrder = 0
      end
      object ReportExprE: TfrxComboEdit
        Left = 0
        Top = 188
        Width = 393
        Height = 21
        Style = csSimple
        ItemHeight = 13
        TabOrder = 1
        OnButtonClick = ExprClick
      end
      object ReportNameE: TfrxComboEdit
        Left = 0
        Top = 20
        Width = 393
        Height = 21
        Style = csSimple
        ItemHeight = 13
        TabOrder = 2
        OnButtonClick = ReportNameEButtonClick
      end
      object ReportParamCB: TComboBox
        Left = 0
        Top = 76
        Width = 393
        Height = 21
        ItemHeight = 13
        TabOrder = 3
      end
    end
    object ReportPageP: TPanel
      Left = 256
      Top = 140
      Width = 393
      Height = 221
      BevelOuter = bvNone
      TabOrder = 5
      object ReportPageValueL: TLabel
        Left = 0
        Top = 112
        Width = 130
        Height = 13
        Caption = 'Specify a parameter value:'
      end
      object ReportPageExprL: TLabel
        Left = 0
        Top = 168
        Width = 269
        Height = 13
        Caption = 'or enter the expression that returns a parameter value:'
      end
      object ReportPageL: TLabel
        Left = 0
        Top = 0
        Width = 64
        Height = 13
        Caption = 'Report page:'
      end
      object ReportPageParamL: TLabel
        Left = 0
        Top = 56
        Width = 90
        Height = 13
        Caption = 'Report parameter:'
      end
      object ReportPageValueE: TEdit
        Left = 0
        Top = 132
        Width = 393
        Height = 21
        TabOrder = 0
      end
      object ReportPageExprE: TfrxComboEdit
        Left = 0
        Top = 188
        Width = 393
        Height = 21
        Style = csSimple
        ItemHeight = 13
        TabOrder = 1
        OnButtonClick = ExprClick
      end
      object ReportPageParamCB: TComboBox
        Left = 0
        Top = 76
        Width = 393
        Height = 21
        ItemHeight = 13
        TabOrder = 2
      end
      object ReportPageCB: TComboBox
        Left = 0
        Top = 20
        Width = 393
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 3
      end
    end
  end
  object ModifyAppearanceCB: TCheckBox
    Left = 8
    Top = 348
    Width = 465
    Height = 17
    Caption = 'Modify appearance'
    TabOrder = 4
  end
  object OpenDialog: TOpenDialog
    Options = [ofReadOnly, ofNoChangeDir, ofEnableSizing]
    Left = 292
    Top = 352
  end
end
