object Form1: TForm1
  Left = 179
  Top = 103
  Caption = 'Print a file'
  ClientHeight = 114
  ClientWidth = 569
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 16
  object SelectLabel: TLabel
    Left = 8
    Top = 24
    Width = 162
    Height = 16
    Caption = 'Select ZUGFeRD XML File:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object CreateButton: TButton
    Left = 144
    Top = 59
    Width = 273
    Height = 45
    Caption = 'Create PDF/A-3b with embedded XML'
    TabOrder = 0
    OnClick = CreateButtonClick
  end
  object XmlEdit: TEdit
    Left = 184
    Top = 21
    Width = 329
    Height = 24
    TabOrder = 1
    Text = 'ZUGFeRD-invoice.xml'
  end
  object SelectButton: TButton
    Left = 519
    Top = 21
    Width = 42
    Height = 25
    Caption = '...'
    TabOrder = 2
    OnClick = SelectButtonClick
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = '.pdf'
    FileName = 'Invoice-With-ZUGFeRD.pdf'
    Filter = 'PDF/A-3a file (*.pdf)|*.pdf|All files (*.*)|*.*'
    Title = 'Select path to save PDF file with embedded ZUGFeRD'
    Left = 440
    Top = 56
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = '.xml'
    Filter = 'ZUGFeRD invoice XML (*.xml)|*.xml|All files (*.*)|*.*'
    Title = 'Select ZUGFeRD XML'
    Left = 512
    Top = 56
  end
  object frxReport1: TfrxReport
    Version = '6.2'
    DotMatrixReport = False
    IniFile = '\Software\Fast Reports'
    PreviewOptions.Buttons = [pbPrint, pbLoad, pbSave, pbExport, pbZoom, pbFind, pbOutline, pbPageSetup, pbTools, pbEdit, pbNavigator, pbExportQuick, pbCopy, pbSelection]
    PreviewOptions.Zoom = 1.000000000000000000
    PrintOptions.Printer = 'Default'
    PrintOptions.PrintOnSheet = 0
    ReportOptions.CreateDate = 43393.872588831020000000
    ReportOptions.LastChange = 43393.872588831020000000
    ScriptLanguage = 'PascalScript'
    ScriptText.Strings = (
      'begin'
      ''
      'end.')
    Left = 16
    Top = 64
    Datasets = <>
    Variables = <>
    Style = <>
  end
  object frxPDFExport1: TfrxPDFExport
    UseFileCache = True
    ShowProgress = True
    OverwritePrompt = False
    DataOnly = False
    OpenAfterExport = False
    PrintOptimized = False
    Outline = False
    Background = False
    HTMLTags = True
    Quality = 95
    Transparency = False
    Author = 'FastReport'
    Subject = 'FastReport PDF export'
    ProtectionFlags = [ePrint, eModify, eCopy, eAnnot]
    HideToolbar = False
    HideMenubar = False
    HideWindowUI = False
    FitWindow = False
    CenterWindow = False
    PrintScaling = False
    PdfA = False
    PDFStandard = psNone
    PDFVersion = pv17
    Left = 88
    Top = 64
  end
end
