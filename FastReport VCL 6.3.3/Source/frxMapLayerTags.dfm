object MapLayerTagsForm: TMapLayerTagsForm
  Tag = 6560
  Left = 622
  Top = 180
  BorderStyle = bsDialog
  Caption = 'MapLayerTagsForm'
  ClientHeight = 257
  ClientWidth = 482
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -10
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  DesignSize = (
    482
    257)
  PixelsPerInch = 96
  TextHeight = 12
  object FileTagsLabel: TLabel
    Tag = 6561
    Left = 6
    Top = 6
    Width = 59
    Height = 12
    Caption = 'FileTagsLabel'
  end
  object LayerTagsLabel: TLabel
    Tag = 6562
    Left = 277
    Top = 6
    Width = 69
    Height = 12
    Caption = 'LayerTagsLabel'
  end
  object FilterLabel: TLabel
    Tag = 6563
    Left = 6
    Top = 239
    Width = 45
    Height = 12
    Caption = 'FilterLabel'
  end
  object CancelB: TButton
    Tag = 2
    Left = 419
    Top = 232
    Width = 57
    Height = 19
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 6
  end
  object OkB: TButton
    Tag = 1
    Left = 362
    Top = 232
    Width = 56
    Height = 19
    Anchors = [akRight, akBottom]
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 5
  end
  object LayerTagsListBox: TListBox
    Left = 277
    Top = 24
    Width = 199
    Height = 199
    ItemHeight = 12
    MultiSelect = True
    TabOrder = 3
  end
  object FilterEdit: TEdit
    Left = 78
    Top = 233
    Width = 127
    Height = 24
    TabOrder = 4
    Text = 'FilterEdit'
    OnKeyPress = FilterEditKeyPress
  end
  object LayerAddButton: TButton
    Left = 216
    Top = 72
    Width = 49
    Height = 19
    Caption = '>>'
    TabOrder = 1
    OnClick = LayerAddButtonClick
  end
  object LayerDeleteButton: TButton
    Left = 216
    Top = 108
    Width = 49
    Height = 19
    Caption = '<<'
    TabOrder = 2
    OnClick = LayerDeleteButtonClick
  end
  object FileTagsListView: TListView
    Left = 6
    Top = 24
    Width = 199
    Height = 199
    Columns = <>
    HideSelection = False
    MultiSelect = True
    ReadOnly = True
    TabOrder = 0
    OnColumnClick = FileTagsListViewColumnClick
  end
end
