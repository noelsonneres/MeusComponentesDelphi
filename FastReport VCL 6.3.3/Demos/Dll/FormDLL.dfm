object frmDLL: TfrmDLL
  Left = 258
  Top = 222
  BorderStyle = bsDialog
  Caption = 'DLL example'
  ClientHeight = 124
  ClientWidth = 267
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnActivate = FormActivate
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object btnBioLifePrintPreview: TButton
    Left = 94
    Top = 56
    Width = 81
    Height = 26
    Caption = 'Print Preview'
    TabOrder = 0
    OnClick = btnBioLifePrintPreviewClick
  end
  object Table1: TTable
    Active = True
    DatabaseName = 'DBDEMOS'
    TableName = 'customer.db'
    Left = 16
    Top = 20
  end
  object frxReport1: TfrxReport
    DotMatrixReport = False
    EngineOptions.MaxMemSize = 10000000
    IniFile = '\Software\Fast Reports'
    PreviewOptions.Buttons = [pbPrint, pbLoad, pbSave, pbExport, pbZoom, pbFind, pbOutline, pbPageSetup, pbTools, pbEdit, pbNavigator]
    PreviewOptions.Zoom = 1.000000000000000000
    PrintOptions.Printer = 'Default'
    ReportOptions.CreateDate = 38208.098787615740000000
    ReportOptions.LastChange = 38208.098787615740000000
    ScriptLanguage = 'PascalScript'
    ScriptText.Strings = (
      'begin'
      ''
      'end.')
    Left = 48
    Top = 20
    Datasets = <
      item
        DataSet = frxDBDataset1
        DataSetName = 'frxDBDataset1'
      end>
    Variables = <>
    Style = <>
    object Page1: TfrxReportPage
      PaperWidth = 209.973333333333300000
      PaperHeight = 296.926000000000000000
      PaperSize = 9
      LeftMargin = 10.000000000000000000
      RightMargin = 10.000000000000000000
      TopMargin = 10.000000000000000000
      BottomMargin = 10.000000000000000000
      object MasterData1: TfrxMasterData
        Height = 22.677180000000000000
        Top = 102.047310000000000000
        Width = 718.009912533333300000
        DataSet = frxDBDataset1
        DataSetName = 'frxDBDataset1'
        RowCount = 0
        object Memo1: TfrxMemoView
          Left = 11.338590000000000000
          Width = 79.370130000000000000
          Height = 18.897650000000000000
          DataField = 'CustNo'
          DataSet = frxDBDataset1
          DataSetName = 'frxDBDataset1'
          Memo.Strings = (
            '1221')
        end
        object Memo2: TfrxMemoView
          Left = 98.267780000000000000
          Width = 238.110390000000000000
          Height = 18.897650000000000000
          DataField = 'Company'
          DataSet = frxDBDataset1
          DataSetName = 'frxDBDataset1'
          Memo.Strings = (
            'Kauai Dive Shoppe')
        end
        object Memo3: TfrxMemoView
          Left = 343.937230000000000000
          Width = 120.944960000000000000
          Height = 18.897650000000000000
          DataField = 'Phone'
          DataSet = frxDBDataset1
          DataSetName = 'frxDBDataset1'
          Memo.Strings = (
            '808-555-0269')
        end
        object Memo4: TfrxMemoView
          Left = 476.220780000000000000
          Width = 120.944960000000000000
          Height = 18.897650000000000000
          DataField = 'FAX'
          DataSet = frxDBDataset1
          DataSetName = 'frxDBDataset1'
          Memo.Strings = (
            '808-555-0278')
        end
      end
      object PageHeader1: TfrxPageHeader
        Height = 22.677180000000000000
        Top = 18.897650000000000000
        Width = 718.009912533333300000
        object Memo5: TfrxMemoView
          Left = 11.338590000000000000
          Width = 79.370130000000000000
          Height = 18.897650000000000000
          Memo.Strings = (
            'CustNo')
        end
        object Memo6: TfrxMemoView
          Left = 98.267780000000000000
          Width = 238.110390000000000000
          Height = 18.897650000000000000
          Memo.Strings = (
            'Company')
        end
        object Memo7: TfrxMemoView
          Left = 343.937230000000000000
          Width = 120.944960000000000000
          Height = 18.897650000000000000
          Memo.Strings = (
            'Phone')
        end
        object Memo8: TfrxMemoView
          Left = 476.220780000000000000
          Width = 120.944960000000000000
          Height = 18.897650000000000000
          Memo.Strings = (
            'FAX')
        end
      end
    end
  end
  object frxDBDataset1: TfrxDBDataset
    UserName = 'frxDBDataset1'
    DataSet = Table1
    Left = 80
    Top = 20
  end
end
