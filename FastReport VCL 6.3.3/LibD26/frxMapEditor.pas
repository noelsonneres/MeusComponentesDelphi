unit frxMapEditor;

interface

{$I frx.inc}

uses
{$IFNDEF FPC}
  Windows, Messages,
{$ELSE}
  LCLType, LCLIntf, LCLProc, LazHelper, ColorBox,
{$ENDIF}
  SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, ComCtrls, StdCtrls, frxCtrls, frxDesgnCtrls,
  frxClass, frxDsgnIntf, frxMap, frxMapLayer, frxMapRanges, frxMapHelpers,
  ExtCtrls, frxMapGeodataLayer
{$IFDEF FPC}
  ,EditBtn
{$ENDIF};

type
  TfrxMapEditorForm = class(TForm)
    MapGroupBox: TGroupBox;
    OkButton: TButton;
    CancelButton: TButton;
    MapTreeView: TTreeView;
    UpButton: TSpeedButton;
    DownButton: TSpeedButton;
    AddButton: TButton;
    DeleteButton: TButton;
    MapOptionsPageControl: TPageControl;
    GeneralTabSheet: TTabSheet;
    MercatorCheckBox: TCheckBox;
    ColorScaleTabSheet: TTabSheet;
    ColorScaleTitleGroupBox: TGroupBox;
    ColorScaleValuesGroupBox: TGroupBox;
    ColorScaleTitleTextLabel: TLabel;
    ColorScaleTitleTextEdit: TEdit;
    ColorScaleValuesFormatLabel: TLabel;
    ColorScaleValuesFormatEdit: TEdit;
    LayerOptionsPageControl: TPageControl;
    DataTabSheet: TTabSheet;
    AppearanceTabSheet: TTabSheet;
    ColorRangesTabSheet: TTabSheet;
    SizeRangesTabSheet: TTabSheet;
    LabelsTabSheet: TTabSheet;
    DataSourceLabel: TLabel;
    FilterLabel: TLabel;
    DatasetComboBox: TComboBox;
    FilterComboEdit: {$IFNDEF FPC}TfrxComboEdit{$ELSE}TEditButton{$ENDIF};
    SpatialDataMapLayerGroupBox: TGroupBox;
    ColumnLabel: TLabel;
    SpatialValueLabel: TLabel;
    SpatialValueComboEdit: {$IFNDEF FPC}TfrxComboEdit{$ELSE}TEditButton{$ENDIF};
    SpatialColumnComboBox: TComboBox;
    AnalyticalDataGroupBox: TGroupBox;
    AnalyticalValueLabel: TLabel;
    FunctionLabel: TLabel;
    AnalyticalValueComboEdit: {$IFNDEF FPC}TfrxComboEdit{$ELSE}TEditButton{$ENDIF};
    FunctionComboBox: TComboBox;
    SpatialDataAppLayerGroupBox: TGroupBox;
    LatitudeLabel: TLabel;
    LatitudeComboEdit: {$IFNDEF FPC}TfrxComboEdit{$ELSE}TEditButton{$ENDIF};
    LongitudeLabel: TLabel;
    LongitudeComboEdit: {$IFNDEF FPC}TfrxComboEdit{$ELSE}TEditButton{$ENDIF};
    LabelLabel: TLabel;
    LabelComboEdit: {$IFNDEF FPC}TfrxComboEdit{$ELSE}TEditButton{$ENDIF};
    ZoomPolygonLabel: TLabel;
    ZoomPolygonComboEdit: {$IFNDEF FPC}TfrxComboEdit{$ELSE}TEditButton{$ENDIF};
    LayerVisibleCheckBox: TCheckBox;
    LayerBorderColorLabel: TLabel;
    LayerBorderStyleLabel: TLabel;
    LayerBorderStyleComboBox: TComboBox;
    LayerBorderWidthLabel: TLabel;
    LayerFillColorLabel: TLabel;
    LayerPaletteLabel: TLabel;
    LayerPaletteComboBox: TComboBox;
    ColorRangeVisibleCheckBox: TCheckBox;
    StartColorLabel: TLabel;
    MiddleColorLabel: TLabel;
    EndColorLabel: TLabel;
    NumColorRangesLabel: TLabel;
    StartSizeLabel: TLabel;
    EndSizeLabel: TLabel;
    NumSizeRangesLabel: TLabel;
    LabelColumnLabel: TLabel;
    LabelColumnComboBox: TComboBox;
    LabelFormatLabel: TLabel;
    LabelFormatEdit: TEdit;
    FontDialog: TFontDialog;
    ColorScaleTitleFontButton: TButton;
    ColorScaleTitleFontSampleLabel: TLabel;
    ColorScaleValuesFontSampleLabel: TLabel;
    ColorScaleValuesFontButton: TButton;
    MapSamplePaintBox: TPaintBox;
    KeepAspectCheckBox: TCheckBox;
    ColorScaleVisibleCheckBox: TCheckBox;
    ColorBorderColorBox: TColorBox;
    ColorBorderWidthLabel: TLabel;
    ColorBorderColorLabel: TLabel;
    ColorTopLeftSpeedButton: TSpeedButton;
    ColorMiddleCenterSpeedButton: TSpeedButton;
    ColorBottomRightSpeedButton: TSpeedButton;
    ColorBottomCenterSpeedButton: TSpeedButton;
    ColorBottomLeftSpeedButton: TSpeedButton;
    ColorMiddleRightSpeedButton: TSpeedButton;
    ColorMiddleLeftSpeedButton: TSpeedButton;
    ColorTopRightSpeedButton: TSpeedButton;
    ColorTopCenterSpeedButton: TSpeedButton;
    ColorScaleDockLabel: TLabel;
    SizeScaleTabSheet: TTabSheet;
    SizeScaleVisibleCheckBox: TCheckBox;
    SizeBorderColorBox: TColorBox;
    SizeScaleValuesGroupBox: TGroupBox;
    SizeScaleValuesFormatLabel: TLabel;
    SizeScaleValuesFontSampleLabel: TLabel;
    SizeScaleValuesFormatEdit: TEdit;
    SizeScaleValuesFontButton: TButton;
    SizeScaleTitleGroupBox: TGroupBox;
    SizeScaleTitleTextLabel: TLabel;
    SizeScaleTitleFontSampleLabel: TLabel;
    SizeScaleTitleTextEdit: TEdit;
    SizeScaleTitleFontButton: TButton;
    SizeScaleDockLabel: TLabel;
    SizeTopCenterSpeedButton: TSpeedButton;
    SizeTopRightSpeedButton: TSpeedButton;
    SizeMiddleLeftSpeedButton: TSpeedButton;
    SizeMiddleRightSpeedButton: TSpeedButton;
    SizeBottomLeftSpeedButton: TSpeedButton;
    SizeBottomCenterSpeedButton: TSpeedButton;
    SizeBottomRightSpeedButton: TSpeedButton;
    SizeMiddleCenterSpeedButton: TSpeedButton;
    SizeTopLeftSpeedButton: TSpeedButton;
    SizeBorderColorLabel: TLabel;
    SizeBorderWidthLabel: TLabel;
    LayerBorderColorColorBox: TColorBox;
    LayerFillColorColorBox: TColorBox;
    LayerPointSizeLabel: TLabel;
    ColorRangeFactorComboBox: TComboBox;
    ColorRangeFactorLabel: TLabel;
    StartColorColorBox: TColorBox;
    MiddleColorColorBox: TColorBox;
    EndColorColorBox: TColorBox;
    SizeRangeVisibleCheckBox: TCheckBox;
    SizeRangeFactorComboBox: TComboBox;
    SizeRangeFactorLabel: TLabel;
    LabelKindLabel: TLabel;
    LabelKindComboBox: TComboBox;
    LabelFontButton: TButton;
    LabelFontLabel: TLabel;
    FillButton: TButton;
    FrameButton: TButton;
    LayerHighlightColorLabel: TLabel;
    LayerHighlightColorColorBox: TColorBox;
    ColorBorderWidthEdit: TEdit;
    ColorBorderWidthUpDown: TUpDown;
    SizeBorderWidthEdit: TEdit;
    SizeBorderWidthUpDown: TUpDown;
    LayerBorderWidthEdit: TEdit;
    LayerBorderWidthUpDown: TUpDown;
    LayerPointSizeEdit: TEdit;
    LayerPointSizeUpDown: TUpDown;
    NumColorRangesEdit: TEdit;
    NumColorRangesUpDown: TUpDown;
    NumSizeRangesEdit: TEdit;
    NumSizeRangesUpDown: TUpDown;
    StartSizeEdit: TEdit;
    StartSizeUpDown: TUpDown;
    EndSizeEdit: TEdit;
    EndSizeUpDown: TUpDown;
    CREditBtn: TButton;
    SREditBtn: TButton;
    GeodataLayerGroupBox: TGroupBox;
    DataColumnComboBox: TComboBox;
    DataColumnLabel: TLabel;
    BorderColorLabel: TLabel;
    FillColorLabel: TLabel;
    BorderColorColumnComboBox: TComboBox;
    FillColorColumnComboBox: TComboBox;
    procedure AddButtonClick(Sender: TObject);
    procedure DeleteButtonClick(Sender: TObject);
    procedure UpButtonClick(Sender: TObject);
    procedure DownButtonClick(Sender: TObject);
    procedure MapTreeViewChange(Sender: TObject; Node: TTreeNode);
    procedure FormShow(Sender: TObject);
    procedure MapSamplePaintBoxPaint(Sender: TObject);
    procedure ComboBoxChange(Sender: TObject);
    procedure ComboEditButtonClick(Sender: TObject);
    procedure ComboEditChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure ColorBoxChange(Sender: TObject);
    procedure SpinEditChange(Sender: TObject);
    procedure EditIntKeyPress(Sender: TObject; var Key: Char);
    procedure DockSpeedButtonClick(Sender: TObject);
    procedure EditChange(Sender: TObject);
    procedure CheckBoxClick(Sender: TObject);
    procedure FontButtonClick(Sender: TObject);
    procedure FillButtonClick(Sender: TObject);
    procedure FrameButtonClick(Sender: TObject);
    procedure CREditBtnClick(Sender: TObject);
    procedure SREditBtnClick(Sender: TObject);
  private
    FMap: TfrxMapView;
    FLayerName: String;
    FOriginalMap: TfrxMapView;
    FReport: TfrxReport;
    FReportDesigner: TfrxCustomDesigner;
    FRefreshEnabled: Boolean;
    procedure SetMap(AMap: TfrxMapView);
    procedure PopulateMapTree(SelectedIndex: Integer = -1);
    procedure PopulateMapOptions;
    procedure PopulateLayerOptions;
    function SelectedLayer: TfrxCustomLayer;
    function SelectedLayerType: TLayerType;
    function SelectedMapFileLayer: TfrxMapFileLayer;
    function SelectedApplicationLayer: TfrxApplicationLayer;
    function SelectedGeodataLayer: TfrxMapGeodataLayer;
    function IsGetSelectedLayerIndex(out Index: Integer): boolean;
    procedure Change;
    procedure FontToLabel(Font: TFont; Lbl: TLabel);
    procedure FontDialogToLabel(Font: TFont; Lbl: TLabel);
  protected
    procedure SelectLayer(LayerName: String);
  public
    property Map: TfrxMapView read FMap write SetMap;
    property ReportDesigner: TfrxCustomDesigner read FReportDesigner write FReportDesigner;
  end;

implementation

{$IFNDEF FPC}
{$R *.dfm}
{$ELSE}
{$R *.lfm}
{$ENDIF}

uses
  frxMapLayerForm, frxEditFrame, frxEditFill, frxEditExpr, Contnrs, frxRes,
  Menus, frxCustomEditors, frxMapInteractiveLayer, frxUtils, frxMapILEditor,
  frxMapColorRangeForm, frxMapSizeRangeForm;

const
  mpAddLayer = 1;
  mpDrawInteractiveLayer = 2;

type
  TfrxMapEditor = class(TfrxViewEditor)
  private
    FSelectedLayerName: String;
    FClickOnLayer: Boolean;
    FClickOnInteractiveLayer: Boolean;
  public
    constructor Create(Component: TfrxComponent; Designer: TfrxCustomDesigner; Menu: TMenu); override;
    function Edit: Boolean; override;
    function HasEditor: Boolean; override;
    procedure GetMenuItems; override;
    function Execute(Tag: Integer; Checked: Boolean): Boolean; override;
  end;

{ TfrxMapEditor }

constructor TfrxMapEditor.Create(Component: TfrxComponent; Designer: TfrxCustomDesigner; Menu: TMenu);
begin
  FClickOnLayer := Component is TfrxCustomLayer;
  FClickOnInteractiveLayer := Component is TfrxMapInteractiveLayer;
  FSelectedLayerName := '';
  if FClickOnLayer then
  begin
    inherited Create(Component.Parent, Designer, Menu);
    FSelectedLayerName := Component.Name;
  end
  else
    inherited;
end;

function TfrxMapEditor.Edit: Boolean;
begin
  with TfrxMapEditorForm.Create(nil) do
  begin
    Map := TfrxMapView(Component);
    SelectLayer(FSelectedLayerName);
    ReportDesigner := Self.Designer;
    Result := ShowModal = mrOk;
    Free;
  end;
end;

function TfrxMapEditor.Execute(Tag: Integer; Checked: Boolean): Boolean;
var
  i: Integer;
  c: TfrxComponent;
begin
  Result := inherited Execute(Tag, Checked);

  for i := 0 to Designer.SelectedObjects.Count - 1 do
  begin
    c := Designer.SelectedObjects[i];
    if (c is TfrxMapView) and not (rfDontModify in c.Restrictions) then
    begin
      if Tag = mpAddLayer then
        with TfrxMapLayerForm.Create(nil) do
          try
            EnableInteractive(TfrxMapView(c).Converter.IsHasData);
            if ShowModal = mrOk then
              TfrxMapView(c).AddLayer(LayerType, IsEmbed, MapFile);
            Result := True;
            Break;
          finally
            Free;
          end;
    end
    else if (c is TfrxMapInteractiveLayer) and not (rfDontModify in c.Restrictions) then
    begin
      if Tag = mpDrawInteractiveLayer then
        with TfrxMapILEditorForm.Create(nil) do
          try
            Layer := TfrxMapInteractiveLayer(c);
            ReportDesigner := Self.Designer;
            ShowModal;
            Result := True;
            Break;
          finally
            Free;
          end;
    end;
  end;
end;

procedure TfrxMapEditor.GetMenuItems;
begin
  if not FClickOnLayer then
    AddItem(frxResources.Get('AddLayer'), mpAddLayer);
  if FClickOnInteractiveLayer then
    AddItem(frxResources.Get('DrawInteractiveLayer'), mpDrawInteractiveLayer);

  AddItem('-', -1);

  inherited;
end;

function TfrxMapEditor.HasEditor: Boolean;
begin
  Result := True;
end;

{ TfrxMapEditorForm }

procedure TfrxMapEditorForm.AddButtonClick(Sender: TObject);
begin
  with TfrxMapLayerForm.Create(nil) do
    try
      EnableInteractive(FMap.Converter.IsHasData);
      if ShowModal = mrOk then
      begin
        FMap.AddLayer(LayerType, IsEmbed, MapFile, FReport);
        PopulateMapTree(FMap.Layers.Count - 1);
        MapTreeView.SetFocus;
        Change;
      end;
    finally
      Free;
    end;
end;

procedure TfrxMapEditorForm.Change;
begin
  if FRefreshEnabled then
    MapSamplePaintBox.Refresh;
end;

procedure TfrxMapEditorForm.CheckBoxClick(Sender: TObject);
begin
  with (Sender as TCheckBox) do
    if      Sender = LayerVisibleCheckBox then      SelectedLayer.Visible := Checked
    else if Sender = KeepAspectCheckBox then        FMap.KeepAspectRatio := Checked
    else if Sender = MercatorCheckBox then          FMap.MercatorProjection := Checked
    else if Sender = ColorScaleVisibleCheckBox then FMap.ColorScale.Visible := Checked
    else if Sender = SizeScaleVisibleCheckBox then  FMap.SizeScale.Visible := Checked
    else if Sender = ColorRangeVisibleCheckBox then SelectedLayer.ColorRanges.Visible := Checked
    else if Sender = SizeRangeVisibleCheckBox then  SelectedLayer.SizeRanges.Visible := Checked
    ;
  Change;
end;

procedure TfrxMapEditorForm.ColorBoxChange(Sender: TObject);
begin
  with Sender as TColorBox do
    if      Sender = ColorBorderColorBox then         FMap.ColorScale.BorderColor := Selected
    else if Sender = SizeBorderColorBox then          FMap.SizeScale.BorderColor := Selected
    else if Sender = LayerBorderColorColorBox then    SelectedLayer.DefaultShapeStyle.BorderColor := Selected
    else if Sender = LayerFillColorColorBox then      SelectedLayer.DefaultShapeStyle.FillColor := Selected
    else if Sender = LayerHighlightColorColorBox then SelectedLayer.HighlightColor := Selected
    else if Sender = StartColorColorBox then          SelectedLayer.ColorRanges.StartColor := Selected
    else if Sender = MiddleColorColorBox then         SelectedLayer.ColorRanges.MiddleColor := Selected
    else if Sender = EndColorColorBox then            SelectedLayer.ColorRanges.EndColor := Selected
    ;
  Change;
end;

procedure TfrxMapEditorForm.ComboBoxChange(Sender: TObject);
  procedure SetupComboBox(ComboBox: TComboBox; Column: String);
  begin
    SelectedLayer.GetColumnList(ComboBox.Items);
    ComboBox.ItemIndex := ComboBox.Items.IndexOf(Column);
  end;
begin
  with Sender as TComboBox do
    if Sender = DataSetComboBox then
    begin
      SelectedLayer.DataSet := FReport.GetDataSet(Items[ItemIndex]);
      if SelectedLayer is TfrxMapGeodataLayer then
      begin
        SetupComboBox(DataColumnComboBox, SelectedGeodataLayer.DataColumn);
        SetupComboBox(BorderColorColumnComboBox, SelectedGeodataLayer.BorderColorColumn);
        SetupComboBox(FillColorColumnComboBox, SelectedGeodataLayer.FillColorColumn);
      end;
    end
    else if Sender = FunctionComboBox then
      SelectedLayer.Operation := TMapOperation(ItemIndex)
    else if Sender = SpatialColumnComboBox then
      SelectedLayer.SpatialColumn := Text
    else if Sender = LayerBorderStyleComboBox then
      SelectedLayer.DefaultShapeStyle.BorderStyle := TPenStyle(ItemIndex)
    else if Sender = LayerPaletteComboBox then
      SelectedLayer.MapPalette := TMapPalette(ItemIndex)
    else if Sender = ColorRangeFactorComboBox then
      SelectedLayer.ColorRanges.RangeFactor := TRangeFactor(ItemIndex)
    else if Sender = SizeRangeFactorComboBox then
      SelectedLayer.SizeRanges.RangeFactor := TRangeFactor(ItemIndex)
    else if Sender = LabelKindComboBox then
      SelectedLayer.LabelKind := TMapLabelKind(ItemIndex)
    else if Sender = LabelColumnComboBox then
      SelectedLayer.LabelColumn := Text
    else if Sender = DataColumnComboBox then
      SelectedGeodataLayer.DataColumn := Text
    else if Sender = BorderColorColumnComboBox then
      SelectedGeodataLayer.BorderColorColumn := Text
    else if Sender = FillColorColumnComboBox then
      SelectedGeodataLayer.FillColorColumn := Text
    ;
  Change;
end;

procedure TfrxMapEditorForm.ComboEditButtonClick(Sender: TObject);
var
  CE: {$IFNDEF FPC}TfrxComboEdit{$ELSE}TEditButton{$ENDIF};
  NewText: String;
begin
  CE := Sender as {$IFNDEF FPC}TfrxComboEdit{$ELSE}TEditButton{$ENDIF};
  if ReportDesigner.IsChangedExpression(CE.Text, NewText) then
  begin
    CE.Text := NewText;
    ComboEditChange(Sender);
  end;
end;

procedure TfrxMapEditorForm.ComboEditChange(Sender: TObject);
begin
  with Sender as {$IFNDEF FPC}TfrxComboEdit{$ELSE}TEditButton{$ENDIF} do
    if      Sender = FilterComboEdit then          SelectedLayer.Filter := Text
    else if Sender = ZoomPolygonComboEdit then     SelectedMapFileLayer.ZoomPolygon := Text
    else if Sender = AnalyticalValueComboEdit then SelectedLayer.AnalyticalValue := Text
    else if Sender = SpatialValueComboEdit then    SelectedLayer.SpatialValue := Text
    else if Sender = LatitudeComboEdit then        SelectedApplicationLayer.LatitudeValue := Text
    else if Sender = LongitudeComboEdit then       SelectedApplicationLayer.LongitudeValue := Text
    else if Sender = LabelComboEdit then           SelectedApplicationLayer.LabelValue := Text
    ;
    Change;
end;

procedure TfrxMapEditorForm.DeleteButtonClick(Sender: TObject);
begin
  if SelectedLayer <> nil then
  begin
    SelectedLayer.Free;
    MapTreeView.Selected.Free;
    MapTreeView.SetFocus;
    Change;
  end;
end;

procedure TfrxMapEditorForm.DockSpeedButtonClick(Sender: TObject);
begin
  if      Sender = ColorTopLeftSpeedButton then      FMap.ColorScale.Dock := sdTopLeft
  else if Sender = ColorTopCenterSpeedButton then    FMap.ColorScale.Dock := sdTopCenter
  else if Sender = ColorTopRightSpeedButton then     FMap.ColorScale.Dock := sdTopRight
  else if Sender = ColorMiddleLeftSpeedButton then   FMap.ColorScale.Dock := sdMiddleLeft
  else if Sender = ColorMiddleCenterSpeedButton then FMap.ColorScale.Dock := sdMiddleCenter
  else if Sender = ColorMiddleRightSpeedButton then  FMap.ColorScale.Dock := sdMiddleRight
  else if Sender = ColorBottomLeftSpeedButton then   FMap.ColorScale.Dock := sdBottomLeft
  else if Sender = ColorBottomCenterSpeedButton then FMap.ColorScale.Dock := sdBottomCenter
  else if Sender = ColorBottomRightSpeedButton then  FMap.ColorScale.Dock := sdBottomRight

  else if Sender = SizeTopLeftSpeedButton then      FMap.SizeScale.Dock := sdTopLeft
  else if Sender = SizeTopCenterSpeedButton then    FMap.SizeScale.Dock := sdTopCenter
  else if Sender = SizeTopRightSpeedButton then     FMap.SizeScale.Dock := sdTopRight
  else if Sender = SizeMiddleLeftSpeedButton then   FMap.SizeScale.Dock := sdMiddleLeft
  else if Sender = SizeMiddleCenterSpeedButton then FMap.SizeScale.Dock := sdMiddleCenter
  else if Sender = SizeMiddleRightSpeedButton then  FMap.SizeScale.Dock := sdMiddleRight
  else if Sender = SizeBottomLeftSpeedButton then   FMap.SizeScale.Dock := sdBottomLeft
  else if Sender = SizeBottomCenterSpeedButton then FMap.SizeScale.Dock := sdBottomCenter
  else if Sender = SizeBottomRightSpeedButton then  FMap.SizeScale.Dock := sdBottomRight;
  Change;
end;

procedure TfrxMapEditorForm.DownButtonClick(Sender: TObject);
var
  Index: Integer;
begin
  if IsGetSelectedLayerIndex(Index) and (Index < FMap.Layers.Count - 1) then
  begin
    FMap.Layers.Exchange(Index, Index + 1);
    PopulateMapTree(Index + 1);
    MapTreeView.SetFocus;
    Change;
  end;
end;

procedure TfrxMapEditorForm.EditChange(Sender: TObject);
begin
  with Sender as TEdit do
    if      Sender = ColorScaleTitleTextEdit then    FMap.ColorScale.TitleText := Text
    else if Sender = SizeScaleTitleTextEdit then     FMap.SizeScale.TitleText := Text
    else if Sender = ColorScaleValuesFormatEdit then FMap.ColorScale.ValueFormat := Text
    else if Sender = SizeScaleValuesFormatEdit then  FMap.SizeScale.ValueFormat := Text
    else if Sender = LabelFormatEdit then            SelectedLayer.ValueFormat := Text
    ;
  Change;
end;

procedure TfrxMapEditorForm.EditIntKeyPress(Sender: TObject; var Key: Char);
begin
  case Key of
    Chr(VK_BACK), '0'..'9':
      ;
  else
    key := Chr(0);
  end;
end;

procedure TfrxMapEditorForm.FillButtonClick(Sender: TObject);
begin
  with TfrxFillEditorForm.Create(nil) do
  begin
    IsSimpleFill := False;
    Fill := FMap.Fill;
    if ShowModal = mrOK  then
    begin
      if Fill is TfrxBrushFill then         FMap.FillType := ftBrush
      else if Fill is TfrxGradientFill then FMap.FillType := ftGradient
      else if Fill is TfrxGlassFill then    FMap.FillType := ftGlass;
      FMap.Fill.Assign(Fill);
    end;
    Free;
    Change;
  end;
end;

procedure TfrxMapEditorForm.FontButtonClick(Sender: TObject);
begin
  if      Sender = ColorScaleTitleFontButton then
    FontDialogToLabel(FMap.ColorScale.TitleFont, ColorScaleTitleFontSampleLabel)
  else if Sender = SizeScaleTitleFontButton then
    FontDialogToLabel(FMap.SizeScale.TitleFont, SizeScaleTitleFontSampleLabel)
  else if Sender = ColorScaleValuesFontButton then
    FontDialogToLabel(FMap.ColorScale.Font, ColorScaleValuesFontSampleLabel)
  else if Sender = SizeScaleValuesFontButton then
    FontDialogToLabel(FMap.SizeScale.Font, SizeScaleValuesFontSampleLabel)
  else if Sender = LabelFontButton then
    FontDialogToLabel(SelectedLayer.Font, LabelFontLabel)
  ;
  Change
end;

procedure TfrxMapEditorForm.FontDialogToLabel(Font: TFont; Lbl: TLabel);
begin
  FontDialog.Font.Assign(Font);
  if FontDialog.Execute then
  begin
    Font.Assign(FontDialog.Font);
    FontToLabel(Font, Lbl);
    Change;
  end;
end;

procedure TfrxMapEditorForm.FontToLabel(Font: TFont; Lbl: TLabel);
begin
  Lbl.Caption := Font.Name + ', ' + IntToStr(Font.Size);
  Lbl.Font.Assign(Font);
end;

procedure TfrxMapEditorForm.FormClose(Sender: TObject; var Action: TCloseAction);
var
  c: TfrxComponent;
begin
  if ModalResult = mrOk then
  begin
    ReportDesigner.SelectedObjects.Clear;
    FOriginalMap.AssignAll(FMap);
    if FLayerName = '' then
      ReportDesigner.SelectedObjects.Add(FOriginalMap)
    else
    begin
      c := FOriginalMap.FindObject(FLayerName);
      if Assigned(c) then
        ReportDesigner.SelectedObjects.Add(c);
    end;
    ReportDesigner.ReloadObjects(False);
  end;
  FMap.Free;
end;

procedure TfrxMapEditorForm.FormCreate(Sender: TObject);
begin
  {$IFDEF FPC}
    {$IFDEF LCLGTK2}
    Font.Name := 'DejaVu Sans, Book';
    Font.Size := 8;
    {$ELSE}
    Font.Name := 'Tahoma';
    Font.Size := 8;
    {$ENDIF}
  {$ENDIF}
  Translate(Self);

  GeodataLayerGroupBox.Top := SpatialDataAppLayerGroupBox.Top; // Must be first
  SpatialDataAppLayerGroupBox.Top := SpatialDataMapLayerGroupBox.Top;
  LayerOptionsPageControl.Height := MapOptionsPageControl.Height;
  ClientHeight := MapOptionsPageControl.Height + Round(OkButton.Height * 1.8);
  FRefreshEnabled := True;

  FLayerName := '';

  OperationGetList(FunctionComboBox.Items);
  PenStyleGetList(LayerBorderStyleComboBox.Items);
  PaletteGetList(LayerPaletteComboBox.Items);
  RangeFactorGetList(ColorRangeFactorComboBox.Items);
  RangeFactorGetList(SizeRangeFactorComboBox.Items);
  MapLabelKindGetList(LabelKindComboBox.Items);
  frxResources.MainButtonImages.GetBitmap(100, UpButton.Glyph);
  frxResources.MainButtonImages.GetBitmap(101, DownButton.Glyph);
end;

procedure TfrxMapEditorForm.FormShow(Sender: TObject);
begin
  LayerOptionsPageControl.Left := MapOptionsPageControl.Left;
  ClientWidth := MapOptionsPageControl.Left + MapOptionsPageControl.Width + 8;
  Change;
end;

procedure TfrxMapEditorForm.FrameButtonClick(Sender: TObject);
begin
  with TfrxFrameEditorForm.Create(nil) do
  begin
    Frame := FMap.Frame;
    if ShowModal = mrOK  then
      FMap.Frame.Assign(Frame);
    Free;
    Change;
  end;
end;

function TfrxMapEditorForm.IsGetSelectedLayerIndex(out Index: Integer): boolean;
begin
  Result := SelectedLayer <> nil;
  if Result then
    Index := FMap.Layers.IndexOf(SelectedLayer);
end;

procedure TfrxMapEditorForm.MapSamplePaintBoxPaint(Sender: TObject);
begin
  FMap.GeometrySave;
  FMap.GeometryChange(0, 0, MapSamplePaintBox.Width, MapSamplePaintBox.Height);
  MapSamplePaintBox.Canvas.Lock;
  try
    FMap.Draw(MapSamplePaintBox.Canvas, 1, 1, 0, 0);
  finally
    MapSamplePaintBox.Canvas.Unlock;
    FMap.GeometryRestore;
  end;
end;

procedure TfrxMapEditorForm.MapTreeViewChange(Sender: TObject; Node: TTreeNode);
begin
  if SelectedLayer <> nil then
  begin
    PopulateLayerOptions;
    MapOptionsPageControl.Hide;
    LayerOptionsPageControl.Show;
  end
  else
  begin
    PopulateMapOptions;
    MapOptionsPageControl.Show;
    LayerOptionsPageControl.Hide;
  end;
end;

procedure TfrxMapEditorForm.PopulateLayerOptions;

  procedure MapLayerVisible;
  begin
    SpatialDataMapLayerGroupBox.Visible := SelectedLayerType in [ltMapFile, ltGeodata];
    ZoomPolygonLabel.Visible := SelectedLayerType = ltMapFile;
    ZoomPolygonComboEdit.Visible := SelectedLayerType = ltMapFile;

    SpatialDataAppLayerGroupBox.Visible := SelectedLayerType = ltApplication;
    LabelColumnLabel.Visible := SelectedLayerType in [ltMapFile, ltInteractive, ltGeodata];
    LabelColumnComboBox.Visible := SelectedLayerType in [ltMapFile, ltInteractive, ltGeodata];

    GeodataLayerGroupBox.Visible := SelectedLayerType = ltGeodata;
  end;

  procedure SetupComboBox(ComboBox: TComboBox; Column: String);
  begin
    SelectedLayer.GetColumnList(ComboBox.Items);
    ComboBox.ItemIndex := ComboBox.Items.IndexOf(Column);
  end;

begin
  FRefreshEnabled := False;
  // Data
  FReport.GetDatasetList(DataSetComboBox.Items);
  if SelectedLayer.DataSet = nil then
    DataSetComboBox.ItemIndex := -1
  else
  begin
    DataSetComboBox.ItemIndex := DataSetComboBox.Items.IndexOf(FReport.GetAlias(SelectedLayer.DataSet));
    ComboBoxChange(DataSetComboBox);
  end;
  MapLayerVisible;
  FilterComboEdit.Text := SelectedLayer.Filter;
  AnalyticalValueComboEdit.Text := SelectedLayer.AnalyticalValue;
  FunctionComboBox.ItemIndex := Ord(SelectedLayer.Operation);

  if SelectedLayerType in [ltMapFile, ltGeodata] then
  begin
    SpatialValueComboEdit.Text := SelectedLayer.SpatialValue;

    SetupComboBox(SpatialColumnComboBox, SelectedLayer.SpatialColumn);
  end;

  if      SelectedLayer is TfrxMapFileLayer then
  begin
    ZoomPolygonComboEdit.Text := SelectedMapFileLayer.ZoomPolygon;
  end
  else if SelectedLayer is TfrxMapGeodataLayer then
  begin
    SetupComboBox(DataColumnComboBox, SelectedGeodataLayer.DataColumn);
    SetupComboBox(BorderColorColumnComboBox, SelectedGeodataLayer.BorderColorColumn);
    SetupComboBox(FillColorColumnComboBox, SelectedGeodataLayer.FillColorColumn);
  end
  else if SelectedLayer is TfrxApplicationLayer then
  begin
    LatitudeComboEdit.Text := SelectedApplicationLayer.LatitudeValue;
    LongitudeComboEdit.Text := SelectedApplicationLayer.LongitudeValue;
    LabelComboEdit.Text := SelectedApplicationLayer.LabelValue;
  end;
  // Appearance
  LayerVisibleCheckBox.Checked := SelectedLayer.Visible;
  LayerBorderColorColorBox.Selected := SelectedLayer.DefaultShapeStyle.BorderColor;
  LayerBorderWidthUpDown.Position := SelectedLayer.DefaultShapeStyle.BorderWidth;
  LayerBorderStyleComboBox.ItemIndex := Ord(SelectedLayer.DefaultShapeStyle.BorderStyle);
  LayerFillColorColorBox.Selected := SelectedLayer.DefaultShapeStyle.FillColor;
  LayerPaletteComboBox.ItemIndex := Ord(SelectedLayer.MapPalette);
  LayerPointSizeUpDown.Position := Round(SelectedLayer.DefaultShapeStyle.PointSize);
  LayerHighlightColorColorBox.Selected := SelectedLayer.HighlightColor;
  // Color Ranges
  ColorRangeVisibleCheckBox.Checked := SelectedLayer.ColorRanges.Visible;
  StartColorColorBox.Selected := SelectedLayer.ColorRanges.StartColor;
  MiddleColorColorBox.Selected := SelectedLayer.ColorRanges.MiddleColor;
  EndColorColorBox.Selected := SelectedLayer.ColorRanges.EndColor;
  NumColorRangesUpDown.Position := SelectedLayer.ColorRanges.RangeCount;
  ColorRangeFactorComboBox.ItemIndex := Ord(SelectedLayer.ColorRanges.RangeFactor);
  // Size Ranges
  SizeRangeVisibleCheckBox.Checked := SelectedLayer.SizeRanges.Visible;
  StartSizeUpDown.Position := Round(SelectedLayer.SizeRanges.StartSize);
  EndSizeUpDown.Position := Round(SelectedLayer.SizeRanges.EndSize);
  NumSizeRangesUpDown.Position := SelectedLayer.SizeRanges.RangeCount;
  SizeRangeFactorComboBox.ItemIndex := Ord(SelectedLayer.SizeRanges.RangeFactor);
  // Labels
  LabelKindComboBox.ItemIndex := Ord(SelectedLayer.LabelKind);
  LabelFormatEdit.Text := SelectedLayer.ValueFormat;
  FontToLabel(SelectedLayer.Font, LabelFontLabel);

  if SelectedLayerType in [ltMapFile, ltInteractive, ltGeodata] then
    SetupComboBox(LabelColumnComboBox, SelectedLayer.LabelColumn);
  FRefreshEnabled := True;
end;

procedure TfrxMapEditorForm.PopulateMapOptions;
begin
  FRefreshEnabled := False;
  // General
  MercatorCheckBox.Checked := FMap.MercatorProjection;
  KeepAspectCheckBox.Checked := FMap.KeepAspectRatio;
  // Color Scale
  ColorScaleVisibleCheckBox.Checked := FMap.ColorScale.Visible;
  ColorBorderColorBox.Selected := FMap.ColorScale.BorderColor;
  ColorBorderWidthUpDown.Position := FMap.ColorScale.BorderWidth;
  case FMap.ColorScale.Dock of
    sdTopLeft:      ColorTopLeftSpeedButton.Down := True;
    sdTopCenter:    ColorTopCenterSpeedButton.Down := True;
    sdTopRight:     ColorTopRightSpeedButton.Down := True;
    sdMiddleLeft:   ColorMiddleLeftSpeedButton.Down := True;
    sdMiddleCenter: ColorMiddleCenterSpeedButton.Down := True;
    sdMiddleRight:  ColorMiddleRightSpeedButton.Down := True;
    sdBottomLeft:   ColorBottomLeftSpeedButton.Down := True;
    sdBottomCenter: ColorBottomCenterSpeedButton.Down := True;
    sdBottomRight:  ColorBottomRightSpeedButton.Down := True;
  end;
  //
  ColorScaleTitleTextEdit.Text := FMap.ColorScale.TitleText;
  FontToLabel(FMap.ColorScale.TitleFont, ColorScaleTitleFontSampleLabel);
  //
  ColorScaleValuesFormatEdit.Text := FMap.ColorScale.ValueFormat;
  FontToLabel(FMap.ColorScale.Font, ColorScaleValuesFontSampleLabel);
  // Size Scale
  SizeScaleVisibleCheckBox.Checked := FMap.SizeScale.Visible;
  SizeBorderColorBox.Selected := FMap.SizeScale.BorderColor;
  SizeBorderWidthUpDown.Position := FMap.SizeScale.BorderWidth;
  case FMap.SizeScale.Dock of
    sdTopLeft:      SizeTopLeftSpeedButton.Down := True;
    sdTopCenter:    SizeTopCenterSpeedButton.Down := True;
    sdTopRight:     SizeTopRightSpeedButton.Down := True;
    sdMiddleLeft:   SizeMiddleLeftSpeedButton.Down := True;
    sdMiddleCenter: SizeMiddleCenterSpeedButton.Down := True;
    sdMiddleRight:  SizeMiddleRightSpeedButton.Down := True;
    sdBottomLeft:   SizeBottomLeftSpeedButton.Down := True;
    sdBottomCenter: SizeBottomCenterSpeedButton.Down := True;
    sdBottomRight:  SizeBottomRightSpeedButton.Down := True;
  end;
  //
  SizeScaleTitleTextEdit.Text := FMap.SizeScale.TitleText;
  FontToLabel(FMap.SizeScale.TitleFont, SizeScaleTitleFontSampleLabel);
  //
  SizeScaleValuesFormatEdit.Text := FMap.SizeScale.ValueFormat;
  FontToLabel(FMap.SizeScale.Font, SizeScaleValuesFontSampleLabel);
  //
  FRefreshEnabled := True;
end;

procedure TfrxMapEditorForm.PopulateMapTree(SelectedIndex: Integer);

  procedure AddChild(Parent: TTreeNode; const S: string; AImageIndex,  ASelectedIndex, AStateIndex: Integer; AData: Pointer);
  begin
    with MapTreeView.Items.AddChild(Parent, S) do
    begin
      ImageIndex := AImageIndex;
      SelectedIndex := ASelectedIndex;
      StateIndex := AStateIndex;
      Data := AData;
    end;
  end;

var
  i: Integer;
begin
  MapTreeView.Items.Clear;

  AddChild(nil, 'Map', 0, 0, 0, FMap);
  for i := 0 to FMap.Layers.Count - 1 do
    AddChild(MapTreeView.Items[0], FMap.Layers[i].Name, 1, 1, 1, FMap.Layers[i]);

  MapTreeView.FullExpand;
  MapTreeView.Selected := MapTreeView.Items[SelectedIndex + 1];
end;

function TfrxMapEditorForm.SelectedApplicationLayer: TfrxApplicationLayer;
begin
  Result := SelectedLayer as TfrxApplicationLayer;
end;

function TfrxMapEditorForm.SelectedGeodataLayer: TfrxMapGeodataLayer;
begin
  Result := SelectedLayer as TfrxMapGeodataLayer;
end;

function TfrxMapEditorForm.SelectedLayer: TfrxCustomLayer;
begin
  if (MapTreeView.Selected <> nil) and (TObject(MapTreeView.Selected.Data) is TfrxCustomLayer) then
    Result := TfrxCustomLayer(MapTreeView.Selected.Data)
  else
    Result := nil;
end;

function TfrxMapEditorForm.SelectedLayerType: TLayerType;
begin
  if      SelectedLayer is TfrxMapFileLayer then        Result := ltMapFile
  else if SelectedLayer is TfrxApplicationLayer then    Result := ltApplication
  else if SelectedLayer is TfrxMapInteractiveLayer then Result := ltInteractive
  else if SelectedLayer is TfrxMapGeodataLayer then     Result := ltGeodata
  else
    raise Exception.Create('Unknown Layer Type');
end;

function TfrxMapEditorForm.SelectedMapFileLayer: TfrxMapFileLayer;
begin
  Result := SelectedLayer as TfrxMapFileLayer;
end;

procedure TfrxMapEditorForm.SelectLayer(LayerName: String);
var
  i: Integer;
begin
  FLayerName := LayerName;
  if FLayerName <> '' then
    for i := 0 to MapTreeView.Items.Count - 1 do
      if (TComponent(MapTreeView.Items[i].Data).Name = FLayerName) then
      begin
        MapTreeView.Select([MapTreeView.Items[i]]);
        Break;
      end;
end;

procedure TfrxMapEditorForm.SetMap(AMap: TfrxMapView);
begin
  FOriginalMap := AMap;
  FReport := AMap.Report;
  FMap := TfrxMapView.Create(nil);;
  FMap.AssignAll(FOriginalMap);
  PopulateMapTree;
end;

procedure TfrxMapEditorForm.SpinEditChange(Sender: TObject);
var
  EditValue: Integer;
begin
  if FMap = nil then
    Exit;

  with Sender as TEdit do
    if Text = '' then
      EditValue := 0
    else
      EditValue := StrToInt(Text);

  with Sender as TEdit do
    if      Sender = ColorBorderWidthEdit then
    begin
      ColorBorderWidthUpDown.Position := EditValue;
      FMap.ColorScale.BorderWidth := EditValue;
    end
    else if Sender = SizeBorderWidthEdit then
    begin
      SizeBorderWidthUpDown.Position := EditValue;
      FMap.SizeScale.BorderWidth := EditValue;
    end
    else if Sender = LayerBorderWidthEdit then
    begin
      LayerBorderWidthUpDown.Position := EditValue;
      SelectedLayer.DefaultShapeStyle.BorderWidth := EditValue;
    end
    else if Sender = LayerPointSizeEdit then
    begin
      LayerPointSizeUpDown.Position := EditValue;
      SelectedLayer.DefaultShapeStyle.PointSize := EditValue;
    end
    else if Sender = NumColorRangesEdit then
    begin
      NumColorRangesUpDown.Position := EditValue;
      SelectedLayer.ColorRanges.RangeCount := EditValue;
    end
    else if Sender = NumSizeRangesEdit then
    begin
      NumSizeRangesUpDown.Position := EditValue;
      SelectedLayer.SizeRanges.RangeCount := EditValue;
    end
    else if Sender = StartSizeEdit then
    begin
      StartSizeUpDown.Position := EditValue;
      SelectedLayer.SizeRanges.StartSize := EditValue;
    end
    else if Sender = EndSizeEdit then
    begin
      EndSizeUpDown.Position := EditValue;
      SelectedLayer.SizeRanges.EndSize := EditValue;
    end
    ;
  Change;

end;

procedure TfrxMapEditorForm.UpButtonClick(Sender: TObject);
var
  Index: Integer;
begin
  if IsGetSelectedLayerIndex(Index) and (Index > 0) then
  begin
    FMap.Layers.Exchange(Index, Index - 1);
    PopulateMapTree(Index - 1);
    MapTreeView.SetFocus;
    Change;
  end;
end;

procedure TfrxMapEditorForm.CREditBtnClick(Sender: TObject);
var
  CRCollection: TColorRangeCollection;
begin
  CRCollection := SelectedLayer.ColorRangesData;
  with TMapColorRangeForm.Create(FReportDesigner) do
  begin
    ValueFormat := SelectedLayer.ColorRanges.MapScale.ValueFormat;
    SetCollection(CRCollection);
    if ShowModal = mrOk then
      CRCollection.Assign(GetCollection);
    Free;
  end;
end;

procedure TfrxMapEditorForm.SREditBtnClick(Sender: TObject);
var
  SRCollection: TSizeRangeCollection;
begin
  SRCollection := SelectedLayer.SizeRangesData;
  with TMapSizeRangeForm.Create(FReportDesigner) do
  begin
    ValueFormat := SelectedLayer.SizeRanges.MapScale.ValueFormat;
    SetCollection(SRCollection);
    if ShowModal = mrOk then
      SRCollection.Assign(GetCollection);
    Free;
  end;
end;

initialization
  frxComponentEditors.Register(TfrxMapView, TfrxMapEditor);
  frxComponentEditors.Register(TfrxCustomLayer, TfrxMapEditor);

end.
