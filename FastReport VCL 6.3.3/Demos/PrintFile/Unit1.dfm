object Form1: TForm1
  Left = 179
  Top = 103
  Width = 277
  Height = 162
  Caption = 'Print a file'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
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
    ReportOptions.LastChange = 38007.009173263900000000
    ScriptLanguage = 'PascalScript'
    ScriptText.Strings = (
      'begin'
      ''
      'end.')
    OnGetValue = frxReport1GetValue
    Left = 20
    Top = 28
    Datasets = <>
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
        Height = 75.590600000000000000
        Top = 18.897650000000000000
        Width = 718.000000000000000000
        Stretched = True
        object Memo2: TfrxMemoView
          Left = 283.464750000000000000
          Width = 94.488250000000000000
          Height = 18.897650000000000000
          HAlign = haCenter
          Memo.Strings = (
            'Unit1.pas')
        end
        object Memo4: TfrxMemoView
          Left = 7.559060000000000000
          Top = 26.456710000000000000
          Width = 687.874460000000000000
          Height = 41.574830000000000000
          Memo.Strings = (
            
              'Set Memo3.StretchMode to smActualHeight, MasterData1.Stretched t' +
              'o True.'
            'To print long text, set also MasterData1.AllowSplit to True.')
        end
      end
      object PageFooter1: TfrxPageFooter
        Height = 22.677180000000000000
        Top = 238.110390000000000000
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
      object MasterData1: TfrxMasterData
        Height = 22.677180000000000000
        Top = 154.960730000000000000
        Width = 718.000000000000000000
        AllowSplit = True
        RowCount = 1
        Stretched = True
        object Memo3: TfrxMemoView
          Align = baWidth
          Width = 718.000000000000000000
          Height = 18.897650000000000000
          StretchMode = smActualHeight
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -21
          Font.Name = 'Courier New'
          Font.Style = [fsBold]
          Memo.Strings = (
            '[file]')
          ParentFont = False
        end
      end
    end
  end
end
