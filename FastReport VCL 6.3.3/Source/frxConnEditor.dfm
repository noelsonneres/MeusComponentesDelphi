object frxConnEditorForm: TfrxConnEditorForm
  Left = 321
  Top = 297
  BorderStyle = bsDialog
  Caption = 'Connections'
  ClientHeight = 241
  ClientWidth = 614
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnHide = FormHide
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object NewB: TButton
    Left = 524
    Top = 8
    Width = 75
    Height = 25
    Caption = 'New...'
    TabOrder = 0
    OnClick = NewBClick
  end
  object DeleteB: TButton
    Left = 524
    Top = 72
    Width = 75
    Height = 25
    Caption = 'Delete'
    TabOrder = 2
    OnClick = DeleteBClick
  end
  object ConnLV: TListView
    Left = 4
    Top = 4
    Width = 509
    Height = 233
    Columns = <
      item
        Caption = 'Name'
        Width = 300
      end
      item
        Caption = 'Type'
      end
      item
        Caption = 'Database'
        Width = 150
      end>
    GridLines = True
    HotTrack = True
    ReadOnly = True
    RowSelect = True
    TabOrder = 4
    ViewStyle = vsReport
  end
  object OKB: TButton
    Left = 524
    Top = 205
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Close'
    Default = True
    ModalResult = 1
    TabOrder = 3
    OnClick = OKBClick
  end
  object EditB: TButton
    Left = 524
    Top = 40
    Width = 75
    Height = 25
    Caption = 'Edit'
    TabOrder = 1
    OnClick = EditBClick
  end
  object TestB: TButton
    Left = 524
    Top = 132
    Width = 75
    Height = 25
    Caption = 'Test'
    TabOrder = 5
    OnClick = TestBClick
  end
end
