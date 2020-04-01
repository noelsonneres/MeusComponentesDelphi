object frxMapLayerForm: TfrxMapLayerForm
  Tag = 6367
  Left = 597
  Top = 335
  BorderStyle = bsDialog
  Caption = 'Add Layer'
  ClientHeight = 263
  ClientWidth = 441
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object lblSelect: TLabel
    Tag = 6365
    Left = 12
    Top = 16
    Width = 68
    Height = 13
    Caption = 'Select source:'
  end
  object btnOk: TButton
    Tag = 1
    Left = 277
    Top = 229
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object btnCancel: TButton
    Tag = 2
    Left = 359
    Top = 229
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object rbMapFile: TRadioButton
    Tag = 6363
    Left = 12
    Top = 52
    Width = 413
    Height = 17
    Caption = 'Map file (*.shp, *.osm, *.gpx)'
    Checked = True
    TabOrder = 2
    TabStop = True
  end
  object edMapFile: TfrxComboEdit
    Left = 32
    Top = 76
    Width = 397
    Height = 21
    Style = csSimple
    ItemHeight = 13
    TabOrder = 3
    OnButtonClick = edMapFileButtonClick
  end
  object cbEmbed: TCheckBox
    Tag = 6364
    Left = 32
    Top = 104
    Width = 397
    Height = 17
    Caption = 'Embed the file in the report'
    TabOrder = 4
  end
  object rbAppData: TRadioButton
    Tag = 6366
    Left = 12
    Top = 136
    Width = 413
    Height = 22
    Caption = 'Empty layer with geodata provided by an application'
    TabOrder = 5
  end
  object rbInteractive: TRadioButton
    Tag = 6368
    Left = 12
    Top = 162
    Width = 417
    Height = 22
    Caption = 'Empty interactive layer'
    TabOrder = 6
  end
  object rbGeodata: TRadioButton
    Tag = 6369
    Left = 12
    Top = 188
    Width = 413
    Height = 22
    Caption = 'Layer with geodata provided by an database'
    TabOrder = 7
  end
  object OpenDialog: TOpenDialog
    Filter = 
      'All supported maps|*.shp; *.osm; *.gpx|SHP file|*.shp|OSM file|*' +
      '.osm|GPX file|*.gpx'
    Left = 200
    Top = 12
  end
end
