object Form1: TForm1
  Left = 191
  Top = 114
  Width = 870
  Height = 640
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 862
    Height = 586
    ActivePage = DesignerSheet
    Align = alClient
    TabOrder = 0
    OnChange = PageControl1Change
    object DesignerSheet: TTabSheet
      Caption = 'Designer'
    end
    object PreviewSheet: TTabSheet
      Caption = 'Preview'
      ImageIndex = 1
      object frxPreview1: TfrxPreview
        Left = 0
        Top = 0
        Width = 854
        Height = 558
        Align = alClient
        BorderStyle = bsNone
        OutlineVisible = True
        OutlineWidth = 121
        ThumbnailVisible = False
      end
    end
  end
  object frxReport1: TfrxReport
    Version = '4.0'
    DotMatrixReport = False
    IniFile = '\Software\Fast Reports'
    OldStyleProgress = True
    PreviewOptions.Buttons = [pbPrint, pbLoad, pbSave, pbExport, pbZoom, pbFind, pbOutline, pbPageSetup, pbTools, pbEdit, pbNavigator, pbExportQuick]
    PreviewOptions.Zoom = 1.000000000000000000
    PrintOptions.Printer = 'Default'
    PrintOptions.PrintOnSheet = 0
    ReportOptions.CreateDate = 39069.938386493060000000
    ReportOptions.LastChange = 39069.938386493060000000
    ScriptLanguage = 'PascalScript'
    ScriptText.Strings = (
      'begin'
      ''
      'end.')
    Left = 148
    Top = 116
    Datasets = <>
    Variables = <>
    Style = <>
  end
  object frxDesigner1: TfrxDesigner
    DefaultScriptLanguage = 'PascalScript'
    DefaultFont.Charset = DEFAULT_CHARSET
    DefaultFont.Color = clWindowText
    DefaultFont.Height = -13
    DefaultFont.Name = 'Arial'
    DefaultFont.Style = []
    DefaultLeftMargin = 10.000000000000000000
    DefaultRightMargin = 10.000000000000000000
    DefaultTopMargin = 10.000000000000000000
    DefaultBottomMargin = 10.000000000000000000
    DefaultPaperSize = 9
    DefaultOrientation = poPortrait
    Restrictions = []
    RTLLanguage = False
    Left = 184
    Top = 116
  end
  object MainMenu1: TMainMenu
    Left = 96
    Top = 104
    object File1: TMenuItem
      Caption = 'File'
      object NewMI: TMenuItem
        Caption = 'New...'
      end
      object NewReportMI: TMenuItem
        Caption = 'New Report'
      end
      object NewPageMI: TMenuItem
        Caption = 'New Page'
      end
      object NewDialogMI: TMenuItem
        Caption = 'New Dialog'
      end
      object N9: TMenuItem
        Caption = '-'
      end
      object OpenMI: TMenuItem
        Caption = 'Open...'
      end
      object SaveMI: TMenuItem
        Caption = 'Save'
      end
      object SaveasMI: TMenuItem
        Caption = 'Save as...'
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object PreviewMI: TMenuItem
        Caption = 'Preview'
      end
      object PagesettingsMI: TMenuItem
        Caption = 'Page settings...'
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object ExitMI: TMenuItem
        Caption = 'Exit'
        OnClick = ExitMIClick
      end
    end
    object Edit1: TMenuItem
      Caption = 'Edit'
      object UndoMI: TMenuItem
        Caption = 'Undo'
      end
      object RedoMI: TMenuItem
        Caption = 'Redo'
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object CutMI: TMenuItem
        Caption = 'Cut'
      end
      object CopyMI: TMenuItem
        Caption = 'Copy'
      end
      object PasteMI: TMenuItem
        Caption = 'Paste'
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object DeleteMI: TMenuItem
        Caption = 'Delete'
      end
      object DeletePageMI: TMenuItem
        Caption = 'Delete Page'
      end
      object SelectAllMI: TMenuItem
        Caption = 'Select All'
      end
      object GroupMI: TMenuItem
        Caption = 'Group'
      end
      object UngroupMI: TMenuItem
        Caption = 'Ungroup'
      end
      object EditMI: TMenuItem
        Caption = 'Edit'
      end
      object N6: TMenuItem
        Caption = '-'
      end
      object FindMI: TMenuItem
        Caption = 'Find'
      end
      object ReplaceMI: TMenuItem
        Caption = 'Replace'
      end
      object FindNextMI: TMenuItem
        Caption = 'Find Next'
      end
      object N5: TMenuItem
        Caption = '-'
      end
      object BringtoFrontMI: TMenuItem
        Caption = 'Bring to Front'
      end
      object SendtoBackMI: TMenuItem
        Caption = 'Send to Back'
      end
    end
    object Report1: TMenuItem
      Caption = 'Report'
      object DataMI: TMenuItem
        Caption = 'Data...'
      end
      object VariablesMI: TMenuItem
        Caption = 'Variables...'
      end
      object StylesMI: TMenuItem
        Caption = 'Styles...'
      end
      object ReportOptionsMI: TMenuItem
        Caption = 'Options...'
      end
    end
    object View1: TMenuItem
      Caption = 'View'
      object ToolbarsMI: TMenuItem
        Caption = 'Toolbars'
        object StandardMI: TMenuItem
          Caption = 'Standard'
        end
        object TextMI: TMenuItem
          Caption = 'Text'
        end
        object FrameMI: TMenuItem
          Caption = 'Frame'
        end
        object AlignmentPaletteMI: TMenuItem
          Caption = 'Alignment Palette'
        end
        object ObjectInspectorMI: TMenuItem
          Caption = 'Object Inspector'
        end
        object DataTreeMI: TMenuItem
          Caption = 'Data Tree'
        end
        object ReportTreeMI: TMenuItem
          Caption = 'Report Tree'
        end
      end
      object N7: TMenuItem
        Caption = '-'
      end
      object RulersMI: TMenuItem
        Caption = 'Rulers'
      end
      object GuidesMI: TMenuItem
        Caption = 'Guides'
      end
      object DeleteGuidesMI: TMenuItem
        Caption = 'Delete Guides'
      end
      object N8: TMenuItem
        Caption = '-'
      end
      object OptionsMI: TMenuItem
        Caption = 'Options...'
      end
    end
    object Help1: TMenuItem
      Caption = 'Help'
      object HelpContentsMI: TMenuItem
        Caption = 'Help Contents...'
      end
      object AboutFastReportMI: TMenuItem
        Caption = 'About FastReport...'
      end
    end
  end
end
