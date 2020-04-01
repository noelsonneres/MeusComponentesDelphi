object frxObjectInspector: TfrxObjectInspector
  Left = 189
  Top = 109
  Width = 215
  Height = 495
  BorderStyle = bsSizeToolWin
  Caption = 'Object Inspector'
  Color = clBtnFace
  DragKind = dkDock
  DragMode = dmAutomatic
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  KeyPreview = True
  OldCreateOrder = True
  PopupMenu = PopupMenu1
  OnDeactivate = FormDeactivate
  OnEndDock = FormEndDock
  OnKeyDown = FormKeyDown
  OnMouseWheelDown = FormMouseWheelDown
  OnMouseWheelUp = FormMouseWheelUp
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object ObjectsCB: TComboBox
    Left = 0
    Top = 2
    Width = 182
    Height = 21
    Style = csOwnerDrawFixed
    ItemHeight = 15
    Sorted = True
    TabOrder = 1
    OnClick = ObjectsCBClick
    OnDrawItem = ObjectsCBDrawItem
    OnDropDown = ObjectsCBDropDown
  end
  object BackPanel: TPanel
    Left = 0
    Top = 45
    Width = 185
    Height = 309
    BevelOuter = bvNone
    TabOrder = 0
    object Splitter1: TSplitter
      Left = 0
      Top = 241
      Width = 185
      Height = 3
      Cursor = crVSplit
      Align = alBottom
    end
    object Box: TScrollBox
      Left = 0
      Top = 0
      Width = 185
      Height = 241
      HorzScrollBar.Visible = False
      Align = alClient
      BorderStyle = bsNone
      Color = clWindow
      Ctl3D = True
      ParentColor = False
      ParentCtl3D = False
      TabOrder = 0
      object PB: TPaintBox
        Left = 0
        Top = 0
        Width = 185
        Height = 241
        Align = alClient
        OnDblClick = PBDblClick
        OnMouseDown = PBMouseDown
        OnMouseMove = PBMouseMove
        OnMouseUp = PBMouseUp
        OnPaint = PBPaint
      end
      object Edit1: TEdit
        Left = 9
        Top = 30
        Width = 113
        Height = 15
        BorderStyle = bsNone
        TabOrder = 0
        Text = 'Edit1'
        Visible = False
        OnDblClick = EditBtnClick
        OnKeyDown = Edit1KeyDown
        OnKeyPress = Edit1KeyPress
        OnMouseDown = Edit1MouseDown
      end
      object EditPanel: TPanel
        Left = 123
        Top = 30
        Width = 15
        Height = 15
        TabOrder = 1
        Visible = False
        object EditBtn: TSpeedButton
          Left = 0
          Top = 0
          Width = 15
          Height = 15
          Glyph.Data = {
            96000000424D960000000000000076000000280000000A000000040000000100
            0400000000002000000000000000000000001000000010000000000000000000
            80000080000000808000800000008000800080800000C0C0C000808080000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777700
            0000700700700700000070070070070000007777777777000000}
          Margin = 0
          OnClick = EditBtnClick
        end
      end
      object ComboPanel: TPanel
        Left = 139
        Top = 30
        Width = 15
        Height = 15
        TabOrder = 2
        Visible = False
        object ComboBtn: TSpeedButton
          Left = 0
          Top = 0
          Width = 15
          Height = 15
          Glyph.Data = {
            C6000000424DC60000000000000076000000280000000A0000000A0000000100
            0400000000005000000000000000000000001000000010000000000000000000
            80000080000000808000800000008000800080800000C0C0C000808080000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777700
            0000777777777700000077777777770000007777077777000000777000777700
            0000770000077700000070000000770000007777777777000000777777777700
            00007777777777000000}
          Margin = 0
          OnClick = ComboBtnClick
          OnMouseDown = ComboBtnMouseDown
        end
      end
    end
    object HintPanel: TScrollBox
      Left = 0
      Top = 244
      Width = 185
      Height = 65
      HorzScrollBar.Visible = False
      VertScrollBar.Visible = False
      Align = alBottom
      BorderStyle = bsNone
      Color = clWindow
      ParentColor = False
      TabOrder = 1
      object PropL: TLabel
        Left = 0
        Top = 0
        Width = 185
        Height = 16
        Align = alTop
        AutoSize = False
        Caption = 'PropL'
        Color = clInfoBk
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
      end
      object DescrL: TLabel
        Left = 0
        Top = 16
        Width = 185
        Height = 49
        Align = alClient
        AutoSize = False
        Caption = 'DescrL'
        Color = clWhite
        ParentColor = False
        WordWrap = True
      end
    end
  end
  object PopupMenu1: TPopupMenu
    AutoPopup = False
    Left = 46
    Top = 171
    object N11: TMenuItem
      Caption = '1'
      ShortCut = 16472
      OnClick = N11Click
    end
    object N21: TMenuItem
      Caption = '2'
      ShortCut = 16470
      OnClick = N21Click
    end
    object N31: TMenuItem
      Caption = '3'
      ShortCut = 16451
      OnClick = N31Click
    end
    object N41: TMenuItem
      Caption = '4'
      ShortCut = 8238
      OnClick = N11Click
    end
    object N51: TMenuItem
      Caption = '5'
      ShortCut = 8237
      OnClick = N21Click
    end
    object N61: TMenuItem
      Caption = '6'
      ShortCut = 16429
      OnClick = N31Click
    end
  end
end
