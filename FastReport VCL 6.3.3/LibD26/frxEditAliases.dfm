object frxAliasesEditorForm: TfrxAliasesEditorForm
  Left = 185
  Top = 107
  BorderStyle = bsDialog
  Caption = 'Edit Aliases'
  ClientHeight = 386
  ClientWidth = 349
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnHide = FormHide
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object HintL: TLabel
    Left = 232
    Top = 32
    Width = 112
    Height = 13
    Alignment = taRightJustify
    Caption = 'Press Enter to edit item'
  end
  object DSAliasL: TLabel
    Left = 4
    Top = 8
    Width = 62
    Height = 13
    Caption = 'Dataset alias'
  end
  object FieldAliasesL: TLabel
    Left = 4
    Top = 32
    Width = 57
    Height = 13
    Caption = 'Field aliases'
  end
  object AliasesLV: TListView
    Left = 4
    Top = 48
    Width = 341
    Height = 297
    Checkboxes = True
    Columns = <
      item
        Caption = 'User name'
        Width = 170
      end
      item
        Caption = 'Original name'
        Width = 151
      end>
    RowSelect = True
    TabOrder = 1
    ViewStyle = vsReport
    OnEdited = AliasesLVEdited
    OnKeyPress = AliasesLVKeyPress
  end
  object OkB: TButton
    Left = 188
    Top = 356
    Width = 75
    Height = 25
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 4
  end
  object CancelB: TButton
    Left = 268
    Top = 356
    Width = 75
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 5
  end
  object ResetB: TButton
    Left = 4
    Top = 356
    Width = 75
    Height = 25
    Caption = 'Reset'
    TabOrder = 2
    OnClick = ResetBClick
  end
  object DSAliasE: TEdit
    Left = 148
    Top = 4
    Width = 197
    Height = 21
    TabOrder = 0
  end
  object UpdateB: TButton
    Left = 84
    Top = 356
    Width = 75
    Height = 25
    Caption = 'Update'
    TabOrder = 3
    OnClick = UpdateBClick
  end
end
