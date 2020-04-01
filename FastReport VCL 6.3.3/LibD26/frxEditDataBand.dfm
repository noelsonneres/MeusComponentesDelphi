object frxDataBandEditorForm: TfrxDataBandEditorForm
  Left = 200
  Top = 108
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Select DataSet'
  ClientHeight = 301
  ClientWidth = 277
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
  OnHide = FormHide
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object OkB: TButton
    Left = 114
    Top = 268
    Width = 75
    Height = 25
    HelpContext = 40
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object CancelB: TButton
    Left = 194
    Top = 268
    Width = 75
    Height = 25
    HelpContext = 50
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object DatasetGB: TGroupBox
    Left = 8
    Top = 8
    Width = 261
    Height = 181
    Caption = 'Dataset'
    TabOrder = 2
    object RecordsL: TLabel
      Left = 78
      Top = 152
      Width = 93
      Height = 13
      Alignment = taRightJustify
      Caption = 'Number of records:'
    end
    object DatasetsLB: TListBox
      Left = 12
      Top = 20
      Width = 237
      Height = 121
      HelpContext = 88
      Style = lbOwnerDrawFixed
      ItemHeight = 18
      TabOrder = 0
      OnClick = DatasetsLBClick
      OnDblClick = DatasetsLBDblClick
      OnDrawItem = DatasetsLBDrawItem
    end
    object RecordsE: TEdit
      Left = 192
      Top = 148
      Width = 41
      Height = 21
      TabOrder = 1
      Text = '0'
    end
    object RecordsUD: TUpDown
      Left = 233
      Top = 148
      Width = 16
      Height = 21
      Associate = RecordsE
      Max = 32767
      TabOrder = 2
    end
  end
  object FilterGB: TGroupBox
    Left = 8
    Top = 196
    Width = 261
    Height = 57
    Caption = 'Filter'
    TabOrder = 3
    object FilterE: TfrxComboEdit
      Left = 12
      Top = 20
      Width = 237
      Height = 21
      Style = csSimple
      ItemHeight = 13
      TabOrder = 0
      OnButtonClick = FilterEButtonClick
    end
  end
end
