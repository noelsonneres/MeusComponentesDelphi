object Form1: TForm1
  Left = 192
  Top = 148
  Width = 444
  Height = 383
  Caption = 'TfrxUserDataset Demo'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 120
  TextHeight = 16
  object frxReport1: TfrxReport
    Version = '6.2.11'
    DotMatrixReport = False
    EngineOptions.DoublePass = True
    IniFile = '\Software\Fast Reports'
    PreviewOptions.Buttons = [pbPrint, pbLoad, pbSave, pbExport, pbZoom, pbFind, pbOutline, pbPageSetup, pbTools, pbEdit, pbNavigator, pbExportQuick, pbCopy, pbSelection]
    PreviewOptions.OutlineWidth = 180
    PreviewOptions.Zoom = 1.000000000000000000
    PrintOptions.Printer = 'Default'
    PrintOptions.PrintOnSheet = 0
    ReportOptions.CreateDate = 37871.995398692100000000
    ReportOptions.Description.Strings = (
      'Demonstrates how to create simple list report.')
    ReportOptions.LastChange = 42086.327078020790000000
    ReportOptions.VersionBuild = '1'
    ReportOptions.VersionMajor = '12'
    ReportOptions.VersionMinor = '13'
    ReportOptions.VersionRelease = '1'
    ScriptLanguage = 'PascalScript'
    ScriptText.Strings = (
      'begin'
      ''
      'end.')
    Left = 120
    Top = 88
    Datasets = <
      item
        DataSet = frxUserDataSet1
        DataSetName = 'Customers'
      end>
    Variables = <>
    Style = <>
    object Data: TfrxDataPage
      Height = 1000.000000000000000000
      Width = 1000.000000000000000000
    end
    object Page1: TfrxReportPage
      PaperWidth = 210.000000000000000000
      PaperHeight = 297.000000000000000000
      PaperSize = 9
      LeftMargin = 5.000000000000000000
      RightMargin = 5.000000000000000000
      TopMargin = 5.000000000000000000
      BottomMargin = 5.000000000000000000
      Columns = 1
      ColumnWidth = 210.000000000000000000
      ColumnPositions.Strings = (
        '0')
      Frame.Typ = []
      PrintOnPreviousPage = True
      object Band1: TfrxReportTitle
        FillType = ftBrush
        Frame.Typ = []
        Height = 30.236240000000000000
        Top = 18.897650000000000000
        Width = 755.906000000000000000
        object Memo1: TfrxMemoView
          AllowVectorExport = True
          Top = 3.779530000000000000
          Width = 714.331170000000000000
          Height = 26.456710000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -16
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Typ = []
          Fill.BackColor = clGray
          HAlign = haCenter
          Memo.UTF8 = (
            'Customers')
          ParentFont = False
          VAlign = vaCenter
        end
      end
      object Band2: TfrxPageHeader
        FillType = ftBrush
        Frame.Typ = []
        Height = 34.015770000000000000
        Top = 71.811070000000000000
        Width = 755.906000000000000000
        object Memo4: TfrxMemoView
          AllowVectorExport = True
          Left = 204.094620000000000000
          Top = 7.559060000000000000
          Width = 158.740260000000000000
          Height = 18.897650000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clMaroon
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Color = clGray
          Frame.Typ = [ftBottom]
          Fill.BackColor = clWhite
          Memo.UTF8 = (
            'Address')
          ParentFont = False
        end
        object Memo5: TfrxMemoView
          AllowVectorExport = True
          Left = 377.953000000000000000
          Top = 7.559060000000000000
          Width = 120.944960000000000000
          Height = 18.897650000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clMaroon
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Color = clGray
          Frame.Typ = [ftBottom]
          Fill.BackColor = clWhite
          Memo.UTF8 = (
            'Contact')
          ParentFont = False
        end
        object Memo6: TfrxMemoView
          AllowVectorExport = True
          Left = 514.016080000000000000
          Top = 7.559060000000000000
          Width = 83.149660000000000000
          Height = 18.897650000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clMaroon
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Color = clGray
          Frame.Typ = [ftBottom]
          Fill.BackColor = clWhite
          Memo.UTF8 = (
            'Phone')
          ParentFont = False
        end
        object Memo7: TfrxMemoView
          AllowVectorExport = True
          Left = 612.283860000000000000
          Top = 7.559060000000000000
          Width = 102.047310000000000000
          Height = 18.897650000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clMaroon
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Color = clGray
          Frame.Typ = [ftBottom]
          Fill.BackColor = clWhite
          Memo.UTF8 = (
            'Fax')
          ParentFont = False
        end
        object Memo3: TfrxMemoView
          AllowVectorExport = True
          Left = 7.559060000000000000
          Top = 7.559060000000000000
          Width = 181.417440000000000000
          Height = 18.897650000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clMaroon
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Color = clGray
          Frame.Typ = [ftBottom]
          Fill.BackColor = clWhite
          Memo.UTF8 = (
            'Company')
          ParentFont = False
        end
      end
      object Band3: TfrxPageFooter
        FillType = ftBrush
        Frame.Typ = []
        Height = 26.456710000000000000
        Top = 249.448980000000000000
        Width = 755.906000000000000000
        object Memo2: TfrxMemoView
          AllowVectorExport = True
          Left = 3.779530000000000000
          Top = 7.559059999999930000
          Width = 710.551640000000000000
          Height = 15.118120000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = [ftTop]
          Frame.Width = 2.000000000000000000
          Fill.BackColor = clWhite
          HAlign = haRight
          Memo.UTF8 = (
            'Page [Page] of [TotalPages]')
          ParentFont = False
        end
      end
      object Band4: TfrxMasterData
        FillType = ftBrush
        Frame.Typ = []
        Height = 22.677180000000000000
        Top = 166.299320000000000000
        Width = 755.906000000000000000
        Columns = 1
        ColumnWidth = 200.000000000000000000
        ColumnGap = 20.000000000000000000
        DataSet = frxUserDataSet1
        DataSetName = 'Customers'
        RowCount = 0
        object Memo13: TfrxMemoView
          AllowVectorExport = True
          Left = 3.779530000000000000
          Width = 714.331170000000000000
          Height = 18.897650000000000000
          DataSet = frxUserDataSet1
          DataSetName = 'Customers'
          Frame.Typ = []
          Highlight.Font.Charset = DEFAULT_CHARSET
          Highlight.Font.Color = -370606080
          Highlight.Font.Height = -13
          Highlight.Font.Name = 'Arial'
          Highlight.Font.Style = []
          Highlight.Condition = '(<Line#> mod 2) = 0'
          Highlight.FillType = ftBrush
          Highlight.Fill.BackColor = 15790320
          Highlight.Frame.Typ = []
          WordWrap = False
        end
        object Memo9: TfrxMemoView
          AllowVectorExport = True
          Left = 204.094620000000000000
          Width = 173.858380000000000000
          Height = 18.897650000000000000
          DataField = 'Addr1'
          DataSet = frxUserDataSet1
          DataSetName = 'Customers'
          Frame.Typ = []
          Memo.UTF8 = (
            '[Customers."Addr1"]')
        end
        object Memo10: TfrxMemoView
          AllowVectorExport = True
          Left = 377.953000000000000000
          Width = 136.063080000000000000
          Height = 18.897650000000000000
          DataField = 'Contact'
          DataSet = frxUserDataSet1
          DataSetName = 'Customers'
          Frame.Typ = []
          Memo.UTF8 = (
            '[Customers."Contact"]')
        end
        object Memo11: TfrxMemoView
          AllowVectorExport = True
          Left = 514.016080000000000000
          Width = 98.267780000000000000
          Height = 18.897650000000000000
          DataField = 'Phone'
          DataSet = frxUserDataSet1
          DataSetName = 'Customers'
          Frame.Typ = []
          Memo.UTF8 = (
            '[Customers."Phone"]')
        end
        object Memo12: TfrxMemoView
          AllowVectorExport = True
          Left = 612.283860000000000000
          Width = 102.047310000000000000
          Height = 18.897650000000000000
          DataField = 'FAX'
          DataSet = frxUserDataSet1
          DataSetName = 'Customers'
          Frame.Typ = []
          Memo.UTF8 = (
            '[Customers."FAX"]')
        end
        object Memo8: TfrxMemoView
          AllowVectorExport = True
          Left = 7.559060000000000000
          Width = 196.535560000000000000
          Height = 18.897650000000000000
          TagStr = '[Customers."Cust No"]'
          DataField = 'Company'
          DataSet = frxUserDataSet1
          DataSetName = 'Customers'
          Frame.Typ = []
          Memo.UTF8 = (
            '[Customers."Company"]')
        end
      end
    end
  end
  object frxUserDataSet1: TfrxUserDataSet
    UserName = 'Customers'
    OnCheckEOF = frxUserDataSet1CheckEOF
    OnFirst = frxUserDataSet1First
    OnNext = frxUserDataSet1Next
    OnPrior = frxUserDataSet1Prior
    OnGetValue = frxUserDataSet1GetValue
    Left = 160
    Top = 88
  end
  object ADOTable1: TADOTable
    Active = True
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=C:\Program Files (x' +
      '86)\FastReport 6 VCL Enterprise\Demos\Main\demo.mdb;Persist Secu' +
      'rity Info=False'
    CursorType = ctStatic
    TableName = 'customer'
    Left = 208
    Top = 88
  end
end
