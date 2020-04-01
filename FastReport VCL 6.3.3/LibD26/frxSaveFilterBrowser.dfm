object BrowserForm: TBrowserForm
  Tag = 6492
  Left = 286
  Top = 231
  Width = 790
  Height = 795
  Caption = 'BrowserForm'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -10
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 12
  object WebBrowser: TWebBrowser
    Left = 0
    Top = 0
    Width = 774
    Height = 757
    Align = alClient
    TabOrder = 0
    OnNavigateComplete2 = WebBrowserNavigateComplete2
    ControlData = {
      4C000000FF4F00003D4E00000000000000000000000000000000000000000000
      000000004C000000000000000000000001000000E0D057007335CF11AE690800
      2B2E126208000000000000004C0000000114020000000000C000000000000046
      8000000000000000000000000000000000000000000000000000000000000000
      00000000000000000100000000000000000000000000000000000000}
  end
end
