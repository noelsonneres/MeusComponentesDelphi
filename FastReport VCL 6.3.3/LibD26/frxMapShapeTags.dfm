object MapShapeTagsForm: TMapShapeTagsForm
  Tag = 6362
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'MapShapeTagsForm'
  ClientHeight = 257
  ClientWidth = 484
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -10
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  DesignSize = (
    484
    257)
  PixelsPerInch = 96
  TextHeight = 12
  object CancelB: TButton
    Tag = 2
    Left = 422
    Top = 232
    Width = 56
    Height = 19
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 0
  end
  object OkB: TButton
    Tag = 1
    Left = 364
    Top = 232
    Width = 56
    Height = 19
    Anchors = [akRight, akBottom]
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object Memo: TMemo
    Left = 6
    Top = 6
    Width = 343
    Height = 245
    Lines.Strings = (
      'Memo')
    TabOrder = 2
  end
end
