object frxFloatWindow: TfrxFloatWindow
  Left = 320
  Top = 195
  BorderIcons = [biSystemMenu]
  BorderStyle = bsNone
  ClientHeight = 61
  ClientWidth = 213
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  ShowHint = True
  OnDestroy = FormDestroy
  OnPaint = FormPaint
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object CloseBtn: TSpeedButton
    Left = 200
    Top = 0
    Width = 11
    Height = 11
    Flat = True
    Glyph.Data = {
      8E000000424D8E00000000000000760000002800000006000000060000000100
      0400000000001800000000000000000000001000000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777000077
      000070000700770077007000070000770000}
    Margin = 1
    Spacing = 0
    OnClick = CloseBtnClick
  end
end
