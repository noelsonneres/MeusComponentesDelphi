object frmCallDLL: TfrmCallDLL
  Left = 277
  Top = 268
  BorderStyle = bsDialog
  Caption = 'DLL example'
  ClientHeight = 92
  ClientWidth = 220
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object btnCallDLL: TButton
    Left = 74
    Top = 19
    Width = 80
    Height = 26
    Caption = 'Call DLL'
    TabOrder = 0
    OnClick = btnCallDLLClick
  end
  object btnClose: TButton
    Left = 75
    Top = 49
    Width = 80
    Height = 26
    Caption = 'Close'
    TabOrder = 1
    OnClick = btnCloseClick
  end
  object Database1: TDatabase
    Connected = True
    DatabaseName = 'dbBDE'
    DriverName = 'STANDARD'
    SessionName = 'Default'
    Left = 16
    Top = 19
  end
end
