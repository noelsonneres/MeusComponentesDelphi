object Form1: TForm1
  Left = 179
  Top = 103
  Width = 277
  Height = 162
  Caption = 'Print a stringlist'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 92
    Top = 84
    Width = 75
    Height = 25
    Caption = 'Print!'
    TabOrder = 0
    OnClick = Button1Click
  end
  object frxReport1: TfrxReport
    DotMatrixReport = False
    EngineOptions.MaxMemSize = 10000000
    IniFile = '\Software\Fast Reports'
    PreviewOptions.Buttons = [pbPrint, pbLoad, pbSave, pbExport, pbZoom, pbFind, pbOutline, pbPageSetup, pbTools, pbEdit, pbNavigator]
    PreviewOptions.Zoom = 1.000000000000000000
    PrintOptions.Printer = 'Default'
    ReportOptions.CreateDate = 38006.786384259300000000
    ReportOptions.LastChange = 38007.009433217600000000
    ScriptLanguage = 'PascalScript'
    ScriptText.Strings = (
      'begin'
      ''
      'end.')
    OnGetValue = frxReport1GetValue
    Left = 20
    Top = 28
    Datasets = <
      item
        DataSet = StringDS
        DataSetName = 'StringDS'
      end>
    Variables = <>
    Style = <>
    object Page1: TfrxReportPage
      PaperWidth = 210.000000000000000000
      PaperHeight = 297.000000000000000000
      PaperSize = 9
      LeftMargin = 10.000000000000000000
      RightMargin = 10.000000000000000000
      TopMargin = 10.000000000000000000
      BottomMargin = 10.000000000000000000
      object ReportTitle1: TfrxReportTitle
        Height = 22.677180000000000000
        Top = 18.897650000000000000
        Width = 718.000000000000000000
        object Memo2: TfrxMemoView
          Left = 283.464750000000000000
          Width = 94.488250000000000000
          Height = 18.897650000000000000
          HAlign = haCenter
          Memo.Strings = (
            'StringList')
        end
      end
      object MasterData1: TfrxMasterData
        Height = 22.677180000000000000
        Top = 102.047310000000000000
        Width = 718.000000000000000000
        DataSet = StringDS
        DataSetName = 'StringDS'
        RowCount = 0
        object Memo3: TfrxMemoView
          Left = 11.338590000000000000
          Width = 94.488250000000000000
          Height = 18.897650000000000000
          Memo.Strings = (
            '[element]')
        end
      end
      object PageFooter1: TfrxPageFooter
        Height = 22.677180000000000000
        Top = 185.196970000000000000
        Width = 718.000000000000000000
        object Memo1: TfrxMemoView
          Left = 642.419312533333000000
          Width = 75.590600000000000000
          Height = 18.897650000000000000
          HAlign = haRight
          Memo.Strings = (
            '[Page#]')
        end
      end
    end
  end
  object StringDS: TfrxUserDataSet
    UserName = 'StringDS'
    Left = 56
    Top = 28
  end
end
