unit frxChartEditorLaz;

{$I frx.inc}

interface

uses
  Classes, SysUtils, FileUtil, LCLIntf, LCLType,
  Forms, Controls, Graphics, Dialogs,
   frxClass, frxChartLaz, frxCustomEditors,
   frxInsp,  ComCtrls,
  ExtCtrls, Buttons, StdCtrls, Grids, Spin, Menus,
  TAGraph, TACustomSeries, TASources, TAStyles,
  TATransformations;

type

  { TfrxChartEditor }

  TfrxChartEditor = class(TfrxViewEditor)
  public
    function Edit: Boolean; override;
    function HasEditor: Boolean; override;
    procedure GetMenuItems; override;
    function Execute(Tag: Integer; Checked: Boolean): Boolean; override;
  end;

  { TLS }

  TLS = class
    FDSPoints: TStrings;
    FDataType: TfrxSeriesDataType;
    FDataSet: TfrxDataSet;
    constructor Create;
    destructor Destroy; override;
  end;



  { TfrxChartEditorForm }

  TfrxChartEditorForm = class(TForm)
    btnDel: TSpeedButton;
    btnOK: TButton;
    btnCancel: TButton;
    btnSData: TButton;
    btnCData: TButton;
    cbDataSet: TComboBox;
    chkSort: TCheckBox;
    dlgColor: TColorDialog;
    gbData: TGroupBox;
    Label1: TLabel;
    lblSource: TLabel;
    mmis1: TMenuItem;
    mmis2: TMenuItem;
    mmit3: TMenuItem;
    mmit4: TMenuItem;
    mmit2: TMenuItem;
    mmit1: TMenuItem;
    mmiDel: TMenuItem;
    mmiIns: TMenuItem;
    pnlSBottom: TPanel;
    pnlSTop: TPanel;
    pgcMain: TPageControl;
    pnlBottom: TPanel;
    pnlRight: TPanel;
    pnlLB: TPanel;
    pnlBtn: TPanel;
    pnlLT: TPanel;
    pnlLeft: TPanel;
    btnAdd: TSpeedButton;
    pmRows: TPopupMenu;
    pmTrans: TPopupMenu;
    pmAS: TPopupMenu;
    rbFixed: TRadioButton;
    rbDataSet: TRadioButton;
    spnY: TSpinEdit;
    srbChart: TScrollBox;
    sgData: TStringGrid;
    tbSeries: TTabSheet;
    tbChart: TTabSheet;
    trvChart: TTreeView;
    procedure btnAddClick(Sender: TObject);
    procedure btnCDataClick(Sender: TObject);
    procedure btnDelClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnSDataClick(Sender: TObject);
    procedure cbDataSetChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure mmiDelClick(Sender: TObject);
    procedure mmiInsClick(Sender: TObject);
    procedure mmiTransClick(Sender: TObject);
    procedure mmiSClick(Sender: TObject);
    procedure pmRowsPopup(Sender: TObject);
    procedure rbDataSetChange(Sender: TObject);
    procedure rbFixedChange(Sender: TObject);
    procedure sgDataButtonClick(Sender: TObject; aCol, aRow: Integer);
    procedure sgDataDrawCell(Sender: TObject; aCol, aRow: Integer;
      aRect: TRect; aState: TGridDrawState);
    procedure sgDataEditingDone(Sender: TObject);
    procedure sgDataPrepareCanvas(sender: TObject; aCol, aRow: Integer;
      aState: TGridDrawState);
    procedure spnYChange(Sender: TObject);
    procedure spnYEnter(Sender: TObject);
    procedure spnYExit(Sender: TObject);
    procedure trvChartChange(Sender: TObject; Node: TTreeNode);
  private
    { private declarations }
    FChart:TfrxChartView;
    FReport: TfrxReport;
    FDesigner: TfrxCustomDesigner;
    FInspector: TfrxObjectInspector;

    FCurNode:TTreeNode;
    FLS: TListChartSource;
    FDataPoints: TStrings;
    FDSPoints: TStrings;
    FTLS: TLS;
    FCurrentRow: Integer;

    FTrans: Integer;
    FMS: Integer;

    procedure ModifyInsp(Sender: TObject);
    procedure AddAxis;
    procedure DelAxis;
    procedure AddMinor;
    procedure DelMinor;
    procedure NewItem;
    procedure DelItem;
    procedure AddSers;
    procedure DelSers;
    procedure AddSty;
    procedure DelSty;
    procedure AddTrans;
    procedure DelTrans;
    procedure AddSource;
    procedure DelSource;
    procedure AddStripe;
    procedure DelStripe;
    procedure FillDropDownLists(ds: TfrxDataset);

    procedure InitGridData;
    function ExtractGridData: Boolean;
    procedure SaveStyles;
    procedure SaveTrans;
    procedure SaveLS;
    procedure ClearLS;
    procedure ClearTrans;
    procedure ClearStripe;
  public
    { public declarations }
    chrtV:TChart;
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;

    property Chart: TfrxChartView read FChart write FChart;
  end;

var
  frxChartEditorForm: TfrxChartEditorForm;

implementation

uses
  math, frxDsgnIntf, frxRes, TASeries,TAMultiSeries,
  TAChartAxisUtils, TAChartAxis,TADrawerCanvas,TAChartUtils,
  TARadialSeries, TAChartTeeChart,
  frxSelSeries, TACustomSource, TAIntervalSources;


{$R *.lfm}

{ TfrxChartEditorForm }

type
  THackSeries = class(TChartSeries);

{ TLS }

constructor TLS.Create;
begin
  FDSPoints := TStringList.Create;
end;

destructor TLS.Destroy;
begin
  FDSPoints.Free;
  inherited Destroy;
end;

procedure TfrxChartEditorForm.FormShow(Sender: TObject);
var
  s, s1:string;
  InspectObj:TPersistent;
  I,J, K, N:Integer;
  Node, Node1, Node2,
    Snode, StNode, Mnode, Tnode: TTreeNode;
  C:TSeriesClass;
  Ls: TListChartSource;
  Obj: TLS;
  Cs: TChartStyles;
  tr: TAxisTransform;
  dti:  TDateTimeIntervalChartSource;


begin
  FReport.GetDatasetList(cbDataSet.Items);

  chrtV := Chart.Chart;
  chrtV.Left := 0;
  chrtV.Top := 0;
  chrtV.Width := Chart.ChWidth;
  chrtV.Height := Chart.ChHeight;
  chrtV.Parent := srbChart;

  Node := trvChart.Items.GetFirstNode;
  Node := Node.GetNext;

  for I := 0 to chrtV.AxisList.Count -1 do
  begin
    Node1 := trvChart.Items.AddChild(Node,
     IntToStr(I) + ' - ' + chrtV.AxisList.Axes[i].DisplayName);
    Node2 := trvChart.Items.AddChild(Node1,'Marks');
    Snode := trvChart.Items.AddChild(Node2,'Source');
    Stnode := trvChart.Items.AddChild(Node2,'Stripes');
    Mnode := trvChart.Items.AddChild(Node1,'Minors');
    Tnode := trvChart.Items.AddChild(Node1,'Transformations');
    for J := 0 to Chart.LSData.Count - 1 do
    begin
      if Chart.LSData[J].NameAS = IntToStr(I) then
      begin
        case Chart.LSData[J].TypeAS of
          1: begin
            SNode.Data := TLS.Create;
            Ls := TListChartSource.Create(nil);
            LS.DataPoints.Assign(Chart.LSData[J].DP);
            LS.YCount := Chart.LSData[J].YCount;
            LS.Sorted := Chart.LSData[J].Sorted;
            TLS(SNode.Data).FDSPoints.Assign(Chart.LSData[J].DDP);
            TLS(SNode.Data).FDataSet := Chart.LSData[J].DataSet;
            TLS(SNode.Data).FDataType := Chart.LSData[J].DataType;
            chrtV.AxisList[I].Marks.Source := Ls;
            SNode.Text := 'List - Source';
          end;
          2: begin
            dti :=  TDateTimeIntervalChartSource.Create(nil);
            dti.Params.Assign(Chart.LSData[J].Params);
            dti.DateTimeFormat := Chart.LSData[J].DateTimeFormat;
            dti.Steps := Chart.LSData[J].Steps;
            dti.SuppressPrevUnit := Chart.LSData[J].SuppressPrevUnit;
            chrtV.AxisList[I].Marks.Source := dti;
            SNode.Text := 'DateTime - Source';
          end;
        end;
        Break;
      end;
    end;

    for J := 0 to Chart.TransData.Count - 1 do
    begin
      s := Chart.TransData[J].NameTr;
      if (LeftStr(s, Pos('+',s) - 1) = IntToStr(I)) and
        (Copy(s, Pos('+', s) + 1,
          Pos('-',s) - Pos('+', s) - 1) = IntToStr(J)) then
       begin
         if chrtv.AxisList[I].Transformations = nil then
           chrtv.AxisList[I].Transformations :=
             TChartAxisTransformations.Create(nil);
         K := StrToInt(Copy(s, Pos('-',s) + 1, Length(s)));
         tr := CTransform[K].Create(nil);
           case K of
             1:begin
               TLinearAxisTransform(tr).Offset := Chart.TransData[J].Offset;
               TLinearAxisTransform(tr).Scale :=  Chart.TransData[J].Scale;
               tr.Enabled :=  Chart.TransData[J].Enabled;
             end;
             2:begin
               TAutoScaleAxisTransform(tr).MinValue := Chart.TransData[J].MinValue;
               TAutoScaleAxisTransform(tr).MaxValue := Chart.TransData[J].MaxValue;
               tr.Enabled :=  Chart.TransData[J].Enabled;
             end;
             3: begin
               TLogarithmAxisTransform(tr).Base := Chart.TransData[J].Base;
               tr.Enabled :=  Chart.TransData[J].Enabled;
             end;
             4: tr.Enabled :=  Chart.TransData[J].Enabled;
           end;
           tr.Transformations := chrtv.AxisList.Axes[I].Transformations;
           trvChart.Items.AddChild(TNode,IntToStr(J) + ' - ' + NTransform[K]);
       end;
    end;

    for J := 0 to Chart.StyData.Count - 1 do
    begin
      s := Chart.StyData[J].NmSer;
      if LeftStr(s, Pos('+', s) - 1) = IntToStr(I) then
      begin
        if chrtV.AxisList[I].Marks.Stripes = nil then
          chrtV.AxisList[I].Marks.Stripes := TChartStyles.Create(nil);
        with TChartStyle(chrtV.AxisList[I].Marks.Stripes.Styles.Add) do
        begin
          Brush.Assign(Chart.StyData[J].Brush);
          Font.Assign(Chart.StyData[J].Font);
          Pen.Assign(Chart.StyData[J].Pen);
          RepeatCount := Chart.StyData[J].RepeatCount;
          UseBrush := Chart.StyData[J].UseBrush;
          UseFont := Chart.StyData[J].UseFont;
          UsePen := Chart.StyData[J].UsePen;
        end;
        trvChart.Items.AddChild(StNode,
          IntToStr(chrtV.AxisList[I].Marks.Stripes.Styles.Count - 1) + ' - ' +
          chrtV.AxisList[I].Marks.Stripes.Styles[J].DisplayName);
      end;
    end;

    if chrtV.AxisList.Axes[i].Minors.Count > 0 then
    for J := 0 to chrtV.AxisList.Axes[i].Minors.Count - 1 do
       trvChart.Items.AddChild(Mnode,
       IntToStr(I) + ' - ' + chrtV.AxisList.Axes[i].Minors[j].DisplayName);
  end;
  // ---------------------------------
  Node := trvChart.Items.GetFirstNode;
  while Node.Text <> 'Series' do
    Node := Node.GetNextSibling;

  for I := 0 to chrtV.Series.Count - 1 do
  begin
    C := TSeriesClass(chrtV.Series[I].ClassType);
    for J := 1 to CntSeries do
      if C = CSeries[J] then
      begin
        N := J;
        Break;
      end;
    Node1 := trvChart.Items.AddChild(Node, NSeries[N] + ' - ' + chrtV.Series[I].Name);
    if chrtV.Series[I] is TChartSeries then
    begin
      for J := 0 to Chart.LSData.Count - 1 do
      begin
        if Chart.LSData[J].NameAS = chrtV.Series[I].Name then
        begin
          LS := TListChartSource.Create(nil);
          LS.DataPoints.Assign(Chart.LSData[J].DP);
          LS.YCount := Chart.LSData[J].YCount;
          LS.Sorted := Chart.LSData[J].Sorted;
          LS.Name := 'Source' + IntToStr(I + 1);
          Obj := TLS.Create;
          Obj.FDSPoints.Assign(Chart.LSData[J].DDP);
          Obj.FDataType := Chart.LSData[J].DataType;
          Obj.FDataSet := Chart.LSData[J].DataSet;
          Node1.Data := Obj;
          TChartSeries(chrtV.Series[I]).Source := LS;
          Break;
        end;
      end;
      if N < 6 then
      begin
        s := chrtV.Series[I].Name;
        Node1 := trvChart.Items.AddChild(Node1, 'Styles');
        for K := 0 to Chart.StyData.Count - 1 do
        begin
          s1 := Chart.StyData[K].NmSer;
          if Pos(s,s1) = 1 then
          begin
            if THackSeries(chrtV.Series[I]).Styles = nil then
            begin
              Cs := TChartStyles.Create(nil);
              THackSeries(chrtV.Series[I]).Styles := Cs;
            end;
            with TChartStyle(Cs.Styles.Add) do
            begin
              Brush.Assign(Chart.StyData[K].Brush);
              Font.Assign(Chart.StyData[K].Font);
              Pen.Assign(Chart.StyData[K].Pen);
              Text := Chart.StyData[K].Text;
              RepeatCount := Chart.StyData[K].RepeatCount;
              UseBrush := Chart.StyData[K].UseBrush;
              UseFont := Chart.StyData[K].UseFont;
              UsePen := Chart.StyData[K].UsePen;
              trvChart.Items.AddChild(Node1,
                Copy(s1, Pos('+', s1) + 1, Length(s1)) + ' - ' + DisplayName);
            end;
          end;
        end;

      end;
    end;
  end;
  Node := trvChart.Items.GetFirstNode;
  FCurNode := Node;
  Node.Selected := True;
  InspectObj := chrtV;
  FInspector.Inspect([InspectObj]);
  tbSeries.Enabled := False;
  trvChart.FullExpand;
end;

procedure TfrxChartEditorForm.mmiDelClick(Sender: TObject);
begin
  if sgData.RowCount <= 2 then
  begin
    sgData.Rows[1].Clear;
    Exit;
  end;
  if InRange(FCurrentRow, 1, sgData.RowCount - 1) then
    sgData.DeleteRow(FCurrentRow);
end;

procedure TfrxChartEditorForm.mmiInsClick(Sender: TObject);
begin
  sgData.InsertColRow(false, FCurrentRow);
end;



procedure TfrxChartEditorForm.mmiTransClick(Sender: TObject);
begin
  FTrans := TMenuItem(Sender).Tag;
end;

procedure TfrxChartEditorForm.mmiSClick(Sender: TObject);
begin
  FMS := TMenuItem(Sender).Tag;
end;

procedure TfrxChartEditorForm.pmRowsPopup(Sender: TObject);
begin
  FCurrentRow := sgData.MouseToCell(sgData.ScreenToClient(Mouse.CursorPos)).Y;
  if not InRange(FCurrentRow, 1, sgData.RowCount - 1) then
    Abort;
  sgData.Row := FCurrentRow;
end;

procedure TfrxChartEditorForm.rbDataSetChange(Sender: TObject);
begin
  if rbDataSet.Checked then
  begin
    FTLS.FDataType := dtDBData;
    cbDataSet.Enabled := True;
    if FTLS.FDataSet <> nil then
    begin
      cbDataSet.ItemIndex := cbDataSet.Items.IndexOf(FTLS.FDataSet.UserName);
    end
    else
      cbDataSet.ItemIndex := -1;
    spnY.Value := FLS.YCount;
    chkSort.Checked := FLS.Sorted;
    InitGridData;
    if cbDataSet.ItemIndex > -1 then
      FillDropDownLists(FTLS.FDataSet);
  end;
end;

procedure TfrxChartEditorForm.rbFixedChange(Sender: TObject);
begin
  if rbFixed.Checked then
  begin
    FTLS.FDataType := dtFixedData;
    cbDataSet.Enabled := False;
    spnY.Value := FLS.YCount;
    chkSort.Checked := FLS.IsSorted;
    InitGridData;
  end
end;

procedure TfrxChartEditorForm.sgDataButtonClick(Sender: TObject; aCol,
  aRow: Integer);
begin
  Unused(Sender);
  if (ARow < 1) or (ACol <> spnY.Value + 2) then exit;
  dlgColor.Color := StrToIntDef(sgData.Cells[ACol, ARow], clRed);
  if not dlgColor.Execute then exit;
  sgData.Cells[ACol, ARow] := IntToColorHex(dlgColor.Color);
end;

procedure TfrxChartEditorForm.sgDataDrawCell(Sender: TObject; aCol,
  aRow: Integer; aRect: TRect; aState: TGridDrawState);
var
  c: Integer;
begin
  Unused(Sender, AState);
  if (ARow < 1) or (ACol <> SpnY.Value + 2) then exit;
  if not TryStrToInt(sgData.Cells[ACol, ARow], c) then exit;
  sgData.Canvas.Pen.Color := clBlack;
  sgData.Canvas.Brush.Color := c;
  InflateRect(ARect, -2, -2);
  ARect.Left := ARect.Right - 12;
  sgData.Canvas.Rectangle(ARect);
end;

procedure TfrxChartEditorForm.sgDataEditingDone(Sender: TObject);
begin
  btnSData.Enabled := True;
  btnCData.Enabled := True;
end;

procedure TfrxChartEditorForm.sgDataPrepareCanvas(sender: TObject; aCol,
  aRow: Integer; aState: TGridDrawState);
var
  ts: TTextStyle;
begin
  Unused(aRow, aState);
  if ACol = 0 then begin
    ts := TStringGrid(Sender).Canvas.TextStyle;
    ts.Alignment := taRightJustify;
    TStringGrid(Sender).Canvas.TextStyle := ts;
  end;
end;

procedure TfrxChartEditorForm.spnYChange(Sender: TObject);
begin
  ExtractGridData;
  FLS.YCount := spnY.Value;
  InitGridData;
  if rbDataSet.Checked then
    FillDropDownLists(FTLS.FDataSet);
end;

procedure TfrxChartEditorForm.spnYEnter(Sender: TObject);
begin
  SpnY.OnChange := spnYChange;
end;

procedure TfrxChartEditorForm.spnYExit(Sender: TObject);
begin
  SpnY.OnChange := nil;
end;

procedure TfrxChartEditorForm.btnAddClick(Sender: TObject);
begin
  NewItem;
end;


procedure TfrxChartEditorForm.btnCDataClick(Sender: TObject);
begin
  if rbFixed.Checked then
  begin
    FDataPoints.Clear;
    FLS.DataPoints := FDataPoints;
    FTLS.FDSPoints.Clear;
    InitGridData;
  end
  else if rbDataSet.Checked  then
  begin
    FDSPoints.Clear;
    FTLS.FDSPoints := FDSPoints;
    FLS.DataPoints.Clear;
    FDataPoints.Clear;
    InitGridData;
    FillDropDownLists(FTLS.FDataSet);
  end;

   btnCData.Enabled := False;
   btnSData.Enabled := False;
end;

procedure TfrxChartEditorForm.btnDelClick(Sender: TObject);
begin
  DelItem;
end;

procedure TfrxChartEditorForm.btnOKClick(Sender: TObject);
begin
  Chart.Chart := chrtV;
  SaveLS;
  SaveTrans;
  SaveStyles;
end;

procedure TfrxChartEditorForm.btnSDataClick(Sender: TObject);
begin
  ExtractGridData;
  if rbFixed.Checked then
  begin
    FLS.DataPoints := FDataPoints;
    FTLS.FDSPoints.Clear;
    FDSPoints.Clear;
  end
  else if rbDataSet.Checked  then
  begin
    FTLS.FDSPoints := FDSPoints;
    FLS.DataPoints.Clear;
    FDataPoints.Clear;
  end;
   FLS.YCount := spnY.Value;
   FLS.Sorted := chkSort.Checked;
   btnSData.Enabled := False;
end;

procedure TfrxChartEditorForm.cbDataSetChange(Sender: TObject);
var
  ds:TfrxDataSet;
begin
  ds := FReport.GetDataSet(cbDataSet.Items[cbDataSet.ItemIndex]);
  FTLS.FDataSet := ds;
  FillDropDownLists(ds);
end;

procedure TfrxChartEditorForm.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  ClearStripe;
  ClearTrans;
  ClearLS;
  CloseAction := caFree;
end;

procedure TfrxChartEditorForm.trvChartChange(Sender: TObject; Node: TTreeNode);
var
  s:string;
  InspectObj:TPersistent;
  I,J,N,N1:Integer;
  nd: TTreeNode;
  Sty: TChartStyles;
begin
  s := Node.Text;
  FCurNode := Node;
  pnlBtn.Enabled := True;
  btnAdd.Enabled := True;
  btnDel.Enabled := True;
  tbSeries.Enabled := False;
  pgcMain.ActivePage := tbChart;
  if s = 'Chart' then
  begin
    pnlBtn.Enabled := False;
    InspectObj := chrtV;
    FInspector.Inspect([InspectObj]);
    Exit;
  end;
  if s = 'Axis' then
  begin
    btnDel.Enabled := False;
    InspectObj := nil;
    FInspector.Inspect([InspectObj]);
    btnAdd.Hint := 'Add Axis';
    Exit;
  end;
  if s = 'Marks' then
  begin
    btnDel.Enabled := False;
    btnAdd.Enabled := False;
    N :=  StrToInt(LeftStr(Node.Parent.Text, Pos(' -', Node.Parent.Text) - 1));
    InspectObj :=
      chrtV.AxisList[N].Marks;
    FInspector.Inspect([InspectObj]);
    Exit;
  end;
  if s = 'Source' then
  begin
    btnAdd.Hint := 'Add Marks source...';
    btnDel.Enabled := False;
    InspectObj := nil;
    FInspector.Inspect([InspectObj]);
    Exit;
  end;
  if s = 'Stripes' then
  begin
    btnAdd.Hint := 'Add Styles for stripes';
    btnDel.Enabled := False;
    InspectObj := nil;
    FInspector.Inspect([InspectObj]);
    Exit;
  end;
  if s = 'Minors' then
  begin
    btnAdd.Hint := 'Add Axis Minor';
    btnDel.Enabled := False;
    InspectObj := nil;
    FInspector.Inspect([InspectObj]);
    Exit;
  end;
  if s = 'Transformations' then
  begin
    btnAdd.Hint := 'Add AxisTransform ...';
    btnDel.Enabled := False;
    InspectObj := nil;
    FInspector.Inspect([InspectObj]);
    Exit;
  end;
  if s = 'Series' then
  begin
    btnAdd.Hint := 'Add series ...';
    btnDel.Enabled := False;
    InspectObj := nil;
    FInspector.Inspect([InspectObj]);
    Exit;
  end;
  if s = 'Styles' then
  begin
    btnAdd.Hint := 'Add Style for series ... ';
    btnDel.Enabled := False;
    InspectObj := nil;
    FInspector.Inspect([InspectObj]);
    Exit;
  end;
  if (Node.Parent <> nil) and (Node.Parent.Text = 'Axis') then
  begin
    btnAdd.Hint := 'Add Axis';
    btnDel.Hint := 'Delete Axis';
    N := StrToInt(LeftStr(s,Pos(' -',s)-1));
    for I := 0 to chrtV.AxisList.Count - 1 do
    begin
       if I = N then
       begin
        InspectObj := chrtV.AxisList[i];
        Break;
       end;
    end;
    FInspector.Inspect([InspectObj]);
    Exit;
  end;

  if (Node.Parent <> nil) and (Node.Parent.Text = 'Marks') then
  begin
    if Pos('-', Node.Text) > 0 then
    begin
      btnAdd.Enabled := False;
      btnDel.Hint := 'Delete Marks Source';
      s := Node.Parent.Parent.Text;
      N := StrToInt(LeftStr(s, Pos(' -',s) - 1));
      InspectObj := chrtV.AxisList[N].Marks.Source;
      if Node.Data <> nil then
      begin
        lblSource.Caption := 'Source for ' + Node.Parent.Parent.Text +
        '.Marks';
        tbSeries.Enabled := True;
        FLS := TListChartSource(chrtV.AxisList[N].Marks.Source);
        FTLS := TLS(Node.Data);
        FDSPoints := FTLS.FDSPoints;
        FDataPoints := FLS.DataPoints;
        rbDataSet.Checked := False;
        rbFixed.Checked := False;

        rbDataSet.Checked := (FTLS.FDataType = dtDBData);
        rbFixed.Checked := (FTLS.FDataType = dtFixedData);
      end;
      FInspector.Inspect([InspectObj]);
    end;
  end;

  if (Node.Parent <> nil) and (Node.Parent.Text = 'Stripes') then
  begin
    btnDel.Hint := 'Delete Style for Stripe';
    s := Node.Parent.Parent.Parent.Text;
    N := StrToInt(LeftStr(s, Pos(' -', s) - 1));
    N1 := StrToInt(LeftStr(Node.Text, Pos(' -', Node.Text) - 1));
    InspectObj := chrtV.AxisList[N].Marks.Stripes.Styles[N1];
    FInspector.Inspect([InspectObj]);
    Application.ProcessMessages;
  end;

  if (Node.Parent <> nil) and (Node.Parent.Text = 'Minors') then
  begin
    btnDel.Hint := 'Delete Minor';
    btnAdd.Enabled := False;
    N := StrToInt(LeftStr(Node.Parent.Parent.Text,Pos(' -',Node.Parent.Parent.Text)-1));
    N1 := StrToInt(LeftStr(s,Pos(' -',s)-1));
    for I := 0 to chrtV.AxisList.Count - 1 do
    begin
      if I = N then
      for J := 0 to chrtV.AxisList[I].Minors.Count - 1 do
      begin
        if J = N1 then
        begin
          InspectObj := chrtV.AxisList[I].Minors[J];
          FInspector.Inspect([InspectObj]);
          Exit;
        end;
      end;
    end;
  end;

  if (Node.Parent <> nil) and (Node.Parent.Text = 'Series') then
  begin
    btnDel.Hint := 'Delete Series';
    lblSource.Caption := 'Source for ' + FCurNode.Text;
    N := StrToInt(RightStr(FCurNode.Text,
     Length(FCurNode.Text) - Pos('Series',FCurNode.Text)-5));
    for I := 0 to chrtV.SeriesCount - 1 do
    begin
      if I = N - 1 then
      begin
        InspectObj := chrtV.Series[I];
        FInspector.Inspect([InspectObj]);
        FTLS := nil;
        if  chrtV.Series[I] is TChartSeries then
        begin
          FTLS := TLS(Node.Data);
          tbSeries.Enabled := True;
          FLS := TListChartSource(TChartSeries(chrtV.Series[I]).Source);

          FDSPoints := FTLS.FDSPoints;
          FDataPoints := FLS.DataPoints;

          rbDataSet.Checked := False;
          rbFixed.Checked := False;

          rbDataSet.Checked := (FTLS.FDataType = dtDBData);
          rbFixed.Checked := (FTLS.FDataType = dtFixedData);
        end;
        Exit;
      end;
    end;
  end;

  if (Node.Parent <> nil) and (Node.Parent.Text = 'Styles') then
  begin
    btnDel.Hint := 'Delete Style';
    btnAdd.Hint := 'Add Style';
    nd := Node;
    while nd.Parent.Text <> 'Series' do
      nd := nd.GetPrev;
    N := StrToInt(RightStr(nd.Text,
      Length(nd.Text) - Pos('Series',nd.Text)-5));
    for I := 0 to chrtV.SeriesCount - 1 do
    begin
      if I = N - 1 then
      begin
        Sty := THackSeries(chrtV.Series[I]).Styles;
        Break;
      end;
    end;
    N := StrToInt(LeftStr(Node.Text, Pos(' -', Node.Text)-1));
    for I := 0 to Sty.Styles.Count - 1 do
    begin
      if I = N then
      begin
        InspectObj := TChartStyle(Sty.Styles[I]);
        FInspector.Inspect([InspectObj]);
        Break;
      end;
    end;
  end;

  if (Node.Parent <> nil) and (Node.Parent.Text = 'Transformations') then
  begin
    btnDel.Hint := 'Delete Transformation';
    nd := Node;
    while nd.Text <> 'Transformations' do
      nd := nd.GetPrev;
    nd := nd.GetPrevSibling;
    nd := nd.GetPrevSibling;
    nd := nd.GetPrev;
    N := StrToInt(LeftStr(nd.Text,Pos(' -',nd.Text)-1));
    N1 := StrToInt(LeftStr(FCurNode.Text,Pos(' -',FCurNode.Text)-1));
    InspectObj :=
      TPersistent(chrtV.AxisList.Axes[N].Transformations.List.Items[N1]);
    FInspector.Inspect([InspectObj]);
  end;


end;

procedure TfrxChartEditorForm.ModifyInsp(Sender: TObject);
var
  I:Integer;
begin
  if (FCurNode.Parent <> nil) and (FCurNode.Parent.Text = 'Axis') then
  begin
    I := StrToInt(LeftStr(FCurNode.Text,Pos(' -',FCurNode.Text)-1));
    FCurNode.Text := IntToStr(I) + ' - ' + chrtV.AxisList[I].DisplayName;
    trvChart.Selected.Text := FCurNode.Text;
  end;
  srbChart.Repaint;
end;

procedure TfrxChartEditorForm.AddAxis;
var
  chax:TChartAxis;
  I:Integer;
  nd, nd2: TTreeNode;
begin
  while FCurNode.Text <> 'Axis' do
    FCurNode := FCurNode.GetPrev;
  chax := TChartAxis.Create(chrtV.AxisList);
  I := chrtV.AxisList.Count - 1;
  nd := trvChart.Items.AddChild(FCurNode, IntToStr(I) + ' - ' + chax.DisplayName);
  nd2 := trvChart.Items.AddChild(nd,'Marks');
  trvChart.Items.AddChild(nd2,'Source');
  trvChart.Items.AddChild(nd2,'Stripes');
  trvChart.Items.AddChild(nd,'Minors');
  trvChart.Items.AddChild(nd,'Transformations');

  nd.Selected := True;
  FCurNode := nd;
end;

procedure TfrxChartEditorForm.DelAxis;
var
  N, J:Integer;
  nd, nd1:TTreeNode;
  tr: TAxisTransform;
  Obj: TLS;
begin
  N := StrToInt(LeftStr(FCurNode.Text,Pos(' -', FCurNode.Text)-1));
  if N = 0 then
    nd := FCurNode.GetPrev
  else
    nd := FCurNode.GetPrevSibling;
  trvChart.Selected := nd;
  if chrtV.AxisList[N].Marks.Source <> nil then
  begin
    if chrtV.AxisList[N].Marks.Source is TListChartSource then
    begin
      nd1 := FCurNode;
      nd1 := nd1.GetNext;
      nd1 := nd1.GetNext;
      Obj := TLS(nd1.Data);
      nd1.Data := nil;
      Obj.Free;
    end;
    chrtV.AxisList[N].Marks.Source.Free;
    chrtV.AxisList[N].Marks.Source := nil;
  end;
  if chrtV.AxisList[N].Transformations <> nil then
  begin
    for J := chrtV.AxisList[N].Transformations.List.Count - 1 downto 0 do
    begin
      tr := TAxisTransform(chrtV.AxisList[N].Transformations.List[J]);
      chrtV.AxisList[N].Transformations.List.Delete(J);
      tr.Free;
    end;
    chrtV.AxisList[N].Transformations.Free;
    chrtV.AxisList[N].Transformations := nil;
  end;
  chrtV.AxisList.Delete(N);
  trvChart.Items.Delete(FCurNode);
  FCurNode := nd;
  if chrtV.AxisList.Count > 0 then
  begin
    while nd.Text <> 'Axis' do
      nd := nd.GetPrev;
    nd := nd.GetNext;
    for N := 0 to chrtV.AxisList.Count - 1 do
    begin
      nd.Text := IntToStr(N) + ' - ' + chrtV.AxisList[N].DisplayName;
      nd := nd.GetNextSibling;
    end;
    trvChart.Selected := FCurNode;
  end;
end;

procedure TfrxChartEditorForm.AddMinor;
var
  cmin:TChartMinorAxis;
  I,J:Integer;
  nd: TTreeNode;
begin
  I := StrToInt(LeftStr(FCurNode.Parent.Text,Pos(' -',FCurNode.Parent.Text)-1));
  cmin := TChartMinorAxis.Create(chrtV.AxisList[I].Minors);
  J := chrtV.AxisList[I].Minors.Count - 1;
  nd :=  trvChart.Items.AddChild(FCurNode, IntToStr(J) + ' - ' + cmin.DisplayName);
  nd.Selected := True;
  FCurNode := nd;
end;

procedure TfrxChartEditorForm.DelMinor;
var
  N, N2:Integer;
  nd:TTreeNode;
begin
  N := StrToInt(LeftStr(FCurNode.Text,Pos(' -', FCurNode.Text)-1));
  N2 := StrToInt(LeftStr(FCurNode.Parent.Parent.Text,Pos(' -', FCurNode.Parent.Parent.Text)-1));
  nd := FCurNode.GetPrev;
  trvChart.Selected := nd;
  chrtV.AxisList[N2].Minors.Delete(N);
  trvChart.Items.Delete(FCurNode);
  FCurNode := nd;
  if chrtV.AxisList[N2].Minors.Count > 0 then
  begin
    while nd.Parent.Text <> 'Minors' do
      nd := nd.GetPrev;
    nd := nd.GetNext;
    for N := 0 to chrtV.AxisList[N2].Minors.Count - 1 do
    begin
      nd.Text := IntToStr(N) + ' - ' + chrtV.AxisList[N2].Minors[N].DisplayName;
      nd := nd.GetNext;
    end;
    trvChart.Selected := FCurNode;
  end;
end;

procedure TfrxChartEditorForm.NewItem;
begin
  if FCurNode.Text = 'Axis' then
  begin
    AddAxis;
    Exit;
  end;
  if (FCurNode.Text = 'Minors') then
  begin
    AddMinor;
    Exit;
  end;
  if (FCurNode.Text = 'Series') or
    ((FCurNode.Parent <> nil) and (FCurNode.Parent.Text = 'Series')) then
  begin
    AddSers;
    Exit;
  end;
  if (FCurNode.Text = 'Styles') or
     ((FCurNode.Parent <> nil) and (FCurNode.Parent.Text = 'Styles')) then
  begin
    AddSty;
    Exit;
  end;
  if (FCurNode.Text = 'Transformations') then
  begin
    AddTrans;
    Exit;
  end;
  if (FCurNode.Text = 'Source') then
  begin
    AddSource;
    Exit;
  end;
  if (FCurNode.Text = 'Stripes') or
     ((FCurNode.Parent <> nil) and (FCurNode.Parent.Text = 'Stripes')) then
  begin
    AddStripe;
    Exit;
  end;
end;

procedure TfrxChartEditorForm.DelItem;
begin
  if FCurNode.Parent.Text = 'Axis'then
  begin
    DelAxis;
    Exit;
  end;
  if (FCurNode.Parent.Text = 'Minors') then
  begin
    DelMinor;
    Exit;
  end;
  if FCurNode.Parent.Text = 'Series' then
  begin
    DelSers;
    Exit;
  end;
  if FCurNode.Parent.Text = 'Styles' then
  begin
    DelSty;
    Exit;
  end;
  if FCurNode.Parent.Text = 'Transformations' then
  begin
    DelTrans;
    Exit;
  end;
  if FCurNode.Parent.Text = 'Marks' then
  begin
    DelSource;
    Exit;
  end;
  if FCurNode.Parent.Text = 'Stripes' then
  begin
    DelStripe;
    Exit;
  end;
end;

procedure TfrxChartEditorForm.AddSers;
var
  I:Integer;
  Node:TTreeNode;
  s:string;
  Sr: TBasicChartSeries;
  Ls: TLS;
begin
  I := GetChTag;
  if I > 0 then
  begin
    case I of
      1: begin
        Sr := TAreaSeries.Create(chrtV);

        chrtV.AddSeries(Sr);
        TChartSeries(Sr).Source := TListChartSource.Create(nil);

        TChartSeries(Sr).Source.Name := 'Source' + IntToStr(chrtV.SeriesCount);
        Ls := Tls.Create;
      end;
      2: begin
        Sr := TBarSeries.Create(chrtV);
        chrtV.AddSeries(Sr);
        TChartSeries(Sr).Source := TListChartSource.Create(nil);
        TChartSeries(Sr).Source.Name := 'Source' + IntToStr(chrtV.SeriesCount);
        Ls := Tls.Create;
      end;
      3: begin
        Sr := THorizBarSeries.Create(chrtV);
        chrtV.AddSeries(Sr);
        TChartSeries(Sr).Source := TListChartSource.Create(nil);
        TChartSeries(Sr).Source.Name := 'Source' + IntToStr(chrtV.SeriesCount);
        Ls := Tls.Create;
      end;
      4: begin
        Sr := TLineSeries.Create(chrtV);
        chrtV.AddSeries(Sr);
        TChartSeries(Sr).Source := TListChartSource.Create(nil);
        TChartSeries(Sr).Source.Name := 'Source' + IntToStr(chrtV.SeriesCount);
        Ls := Tls.Create;
      end;
      5: begin
        Sr := TPointSeries.Create(chrtV);
        TPointSeries(Sr).ShowPoints := True;
        TPointSeries(Sr).LineType := ltNone;
        TPointSeries(Sr).Pointer.Brush.Color := clRed;
        chrtV.AddSeries(Sr);
        TChartSeries(Sr).Source := TListChartSource.Create(nil);
        TChartSeries(Sr).Source.Name := 'Source' + IntToStr(chrtV.SeriesCount);
        Ls := Tls.Create;
      end;
      6: begin
        Sr := TPieSeries.Create(chrtV);
        chrtV.AddSeries(Sr);
        TChartSeries(Sr).Source := TListChartSource.Create(nil);
        TChartSeries(Sr).Source.Name := 'Source' + IntToStr(chrtV.SeriesCount);
        Ls := Tls.Create;
      end;
      7: begin
        Sr := TPolarSeries.Create(chrtV);
        chrtV.AddSeries(Sr);
        TChartSeries(Sr).Source := TListChartSource.Create(nil);
        TChartSeries(Sr).Source.Name := 'Source' + IntToStr(chrtV.SeriesCount);
        Ls := Tls.Create;
      end;
      8: begin
        Sr := TBubbleSeries.Create(chrtV);
        chrtV.AddSeries(Sr);
        TChartSeries(Sr).Source := TListChartSource.Create(nil);
        TChartSeries(Sr).Source.Name :=
          'Source' + IntToStr(chrtV.SeriesCount);
        TChartSeries(Sr).Source.YCount := 2;
        Ls := Tls.Create;
      end;
      9: begin
        Sr := TOpenHighLowCloseSeries.Create(chrtV);
        chrtV.AddSeries(Sr);
        TChartSeries(Sr).Source := TListChartSource.Create(nil);
        TChartSeries(Sr).Source.Name :=
          'Source' + IntToStr(chrtV.SeriesCount);
         TChartSeries(Sr).Source.YCount := 4;
        Ls := Tls.Create;
      end;
      10: begin
        Sr := TBoxAndWhiskerSeries.Create(chrtV);
        chrtV.AddSeries(Sr);
        TChartSeries(Sr).Source := TListChartSource.Create(nil);
        TChartSeries(Sr).Source.Name := 'Source' + IntToStr(chrtV.SeriesCount);
         TChartSeries(Sr).Source.YCount := 5;
         LS := TLS.Create;
      end;
    11: begin
        Sr := TConstantLine.Create(chrtV);
        chrtV.AddSeries(Sr);
        LS := nil;
      end;
    end;
    Node := FCurNode;
    while Node.Text <> 'Series' do
      Node := Node.GetPrev;
    s := NSeries[I] + ' - Series' + IntToStr(chrtV.SeriesCount);
    chrtV.Series[chrtV.SeriesCount - 1].Name := 'Series' + IntToStr(chrtV.SeriesCount);
    Node := trvChart.Items.AddChildObject(Node, s, ls);
    if (I >= 1) and (I <= 5) then
      trvChart.Items.AddChild(Node, 'Styles');
    Node.Selected := True;
    FCurNode := Node;
  end;
end;

procedure TfrxChartEditorForm.DelSers;
var
  I:Integer;
  nd:TTreeNode;
  b: TBasicChartSeries;
  s: string;
  obj: TLS;
begin
  I := StrToInt(RightStr(FCurNode.Text,
    Length(FCurNode.Text) - Pos('- Series', FCurNode.Text) - 7));
  if I = 1 then
    nd := FCurNode.GetPrev
  else
    nd := FCurNode.GetPrevSibling;
  trvChart.Selected := nd;
  if FCurNode.Data <> nil then
  begin
    obj := TLS(FCurNode.Data);
    FCurNode.Data := nil;
    obj.Free;
  end;
  trvChart.Items.Delete(FCurNode);
  if chrtV.Series[I - 1] is TChartSeries then
  begin
    if THackSeries(chrtV.Series[I - 1]).Styles <> nil then
    begin
       THackSeries(chrtV.Series[I - 1]).Styles.Styles.Clear;
       THackSeries(chrtV.Series[I - 1]).Styles.Free;
    end;
    TChartSeries(chrtV.Series[I - 1]).Source.Free;
  end;
  b := chrtV.Series[I - 1];
  chrtV.DeleteSeries(chrtV.Series[I - 1]);
  b.Free;

  FCurNode := nd;

  if chrtV.Series.Count > 0 then
  begin
    while nd.Text <> 'Series' do
      nd := nd.GetPrev;
    nd := nd.GetNext;
    for I := 0 to chrtV.Series.Count - 1 do
    begin
      s := nd.Text;
      s := Copy(s,1, Pos('- Series', s) - 1);
      nd.Text := s + '- Series' + IntToStr(I + 1);
      if chrtV.Series[I].Name <> 'Series' + IntToStr(I + 1) then
         chrtV.Series[I].Name := 'Series' + IntToStr(I + 1);
      if chrtV.Series[I] is TChartSeries then
        TChartSeries(chrtV.Series[I]).Source.Name := 'Source' + IntToStr(I + 1);
      nd := nd.GetNextSibling;
    end;
    trvChart.Selected := FCurNode;
  end;
end;

procedure TfrxChartEditorForm.AddSty;
var
  nd:TTreeNode;
  I,N, Cnt: Integer;
  CSty: TChartStyle;
begin
  while FCurNode.Text <> 'Styles' do
    FCurNode := FCurNode.GetPrev;
  nd := FCurNode;
  while nd.Parent.Text <> 'Series' do
    nd := nd.GetPrev;
  N := StrToInt(RightStr(nd.Text,
    Length(nd.Text) - Pos('Series',nd.Text)-5));
  for I := 0 to chrtV.Series.Count - 1 do
  begin
    if I = N - 1 then
    begin
      if THackSeries(chrtV.Series[I]).Styles = nil then
        THackSeries(chrtV.Series[I]).Styles :=
          TChartStyles.Create(nil);
      CSty := TChartStyle(THackSeries(chrtV.Series[I]).Styles.Styles.Add);
      Cnt := THackSeries(chrtV.Series[I]).Styles.Styles.Count - 1;
      Break;
    end;
  end;

  nd := trvChart.Items.AddChild(FCurNode,
    IntToStr(Cnt) + ' - ' + CSty.DisplayName);
  nd.Selected := True;
  FCurNode := nd;
end;

procedure TfrxChartEditorForm.DelSty;
var
  N, N1, I: Integer;
  nd, nd1: TTreeNode;
  Css:TChartStyles;
  Sr: TChartSeries;
begin
  N := StrToInt(LeftStr(FCurNode.Text, Pos(' -',FCurNode.Text)-1));
  nd := FCurNode.GetPrev;
  nd.Selected := True;
  trvChart.Items.Delete(FCurNode);
  nd1 := nd;
  while nd1.Parent.Text <> 'Series' do
    nd1 := nd1.GetPrev;
  N1 := StrToInt(RightStr(nd1.Text,
    Length(nd1.Text) - Pos('Series', nd1.Text)-5));
  for I := 0 to chrtV.Series.Count - 1 do
  begin
    if I = N1 - 1 then
    begin
      Sr := TChartSeries(chrtV.Series[I]);
      Break;
    end;
  end;
  THackSeries(Sr).Styles.Styles.Delete(N);
  if THackSeries(Sr).Styles.Styles.Count > 0 then
  begin
    while nd1.Text <> 'Styles' do
      nd1 := nd1.GetNext;
    nd1 := nd1.GetNext;
    for I := 0 to THackSeries(Sr).Styles.Styles.Count - 1 do
    begin
      nd1.Text := IntToStr(I) + ' - ' +
        THackSeries(Sr).Styles.Styles[I].DisplayName;
      nd1 := nd1.GetNext;
    end;
  end
  else
  begin
    Css :=  THackSeries(Sr).Styles;
    THackSeries(Sr).Styles := nil;
    Css.Free;
  end;
  FCurNode := nd;
end;

procedure TfrxChartEditorForm.AddTrans;
var
  Sl,N:Integer;
  nd: TTreeNode;
  s: string;
begin
  pmTrans.PopUp;
  Application.ProcessMessages;
  Sl := FTrans;
  FTrans := 0;
  if Sl > 0 then
  begin
    nd := FCurNode;
    nd := nd.GetPrevSibling;
    nd := nd.GetPrevSibling;
    nd := nd.GetPrev;
    N := StrToInt(LeftStr(nd.Text,Pos(' -', nd.Text)-1));
    if chrtv.AxisList[N].Transformations = nil then
      chrtv.AxisList[N].Transformations :=
        TChartAxisTransformations.Create(nil);
    with CTransform[Sl].Create(nil) do
    begin
      Enabled := False;
      Transformations := chrtV.AxisList.Axes[N].Transformations;
    end;
    s := IntToStr(chrtV.AxisList[N].Transformations.List.Count - 1)  +
      ' - ' + NTransform[Sl];
    nd := trvChart.Items.AddChild(FCurNode, s);
    nd.Selected := True;
    FCurNode := nd;
    FCurNode.Selected := True;
  end;
end;

procedure TfrxChartEditorForm.DelTrans;
var
  N, N1, I: Integer;
  tr: TAxisTransform ;
  nd, nd1: TTreeNode;
  s: string;
begin
  N := StrToInt(LeftStr(FCurNode.Text, Pos(' -',FCurNode.Text) - 1));
  nd := FCurNode.GetPrev;
  nd.Selected := True;
  nd1 := nd;
  while nd1.Text <> 'Transformations'  do
    nd1 := nd1.GetPrev;
  nd1 := nd1.GetPrevSibling;
  nd1 := nd1.GetPrevSibling;
  nd1 := nd1.GetPrev;
  N1 := StrToInt(LeftStr(nd1.Text, Pos(' -', nd1.Text) - 1));
  trvChart.Items.Delete(FCurNode);
  tr := TAxisTransform(chrtV.AxisList[N1].Transformations.List.Items[N]);
  chrtV.AxisList[N1].Transformations.List.Delete(N);
  tr.Free;

  if chrtV.AxisList[N1].Transformations.List.Count > 0 then
  begin
    nd1 := nd;
    while nd1.Text <> 'Transformations' do
      nd1 := nd1.GetPrev;
    nd1 := nd1.GetNext;
    for I := 0  to chrtV.AxisList[N].Transformations.List.Count - 1 do
    begin
      s := Copy(nd1.Text, Pos(' -',nd1.Text), Length(nd1.Text));
      nd1.Text := IntToStr(I) + s;
      nd1 := nd1.GetNext;
    end;
  end;
  FCurNode := nd;
end;

procedure TfrxChartEditorForm.AddSource;
var
  Sl,N:Integer;
  s: string;
begin
  pmAS.PopUp;
  Application.ProcessMessages;
  Sl := FMS;
  FMS := 0;
  if Sl > 0 then
  begin
    s := FCurNode.Parent.Parent.Text;
    N := StrToInt(LeftStr(s, Pos(' -', s) - 1));
    case Sl of
    1:begin
        chrtV.AxisList[N].Marks.Source := TListChartSource.Create(nil);
        FCurNode.Text := 'List - Source';
        FCurNode.Data := TLS.Create;
      end;
    2:begin
        chrtV.AxisList[N].Marks.Source := TDateTimeIntervalChartSource.Create(nil);
        FCurNode.Text := 'DateTime - Source';
      end;
    end;
    trvChartChange(trvChart, FCurNode);
  end;
end;

procedure TfrxChartEditorForm.DelSource;
var
  s: string;
  N: Integer;
  Obj: TLS;
begin
  s := FCurNode.Parent.Parent.Text;
  N := StrToInt(LeftStr(s, Pos(' -', s) - 1));
  chrtV.AxisList[N].Marks.Source.Free;
  chrtV.AxisList[N].Marks.Source := nil;
  if FCurNode.Data <> nil then
  begin
    Obj := TLS(FCurNode.Data);
    FCurNode.Data := nil;
    Obj.Free;
  end;
  FCurNode.Text := 'Source';
  trvChartChange(trvChart, FCurNode);
end;

procedure TfrxChartEditorForm.AddStripe;
var
  nd: TTreeNode;
  s: string;
  N, I: Integer;
begin
  while FCurNode.Text <> 'Stripes' do
    FCurNode := FCurNode.GetPrev;
  s := FCurNode.Parent.Parent.Text;
  N := StrToInt(LeftStr(s, Pos(' -', s) - 1));
  if chrtV.AxisList[N].Marks.Stripes = nil then
    chrtV.AxisList[N].Marks.Stripes := TChartStyles.Create(nil);
  chrtV.AxisList[N].Marks.Stripes.Styles.Add;
  I := chrtV.AxisList[N].Marks.Stripes.Styles.Count - 1;
  nd := trvChart.Items.AddChild(FCurNode, IntToStr(I) + ' - ' +
    chrtV.AxisList[N].Marks.Stripes.Styles[I].DisplayName);
  nd.Selected := True;
  FCurNode := nd;
end;

procedure TfrxChartEditorForm.DelStripe;
var
  nd, nd1: TTreeNode;
  N, I: Integer;
  s: string;
begin
  s := FCurNode.Parent.Parent.Parent.Text;
  N := StrToInt(LeftStr(s, Pos(' -', s) - 1));
  I := StrToInt(LeftStr(FCurNode.Text, Pos(' -', FCurNode.Text) - 1));
  nd := FCurNode;
  nd := nd.GetPrev;
  nd.Selected := True;
  chrtV.AxisList[N].Marks.Stripes.Styles.Delete(I);
  trvChart.Items.Delete(FCurNode);
  if chrtV.AxisList[N].Marks.Stripes.Styles.Count > 0 then
  begin
    nd1 := nd;
    while nd1.Text <> 'Stripes' do
      nd1 := nd1.GetPrev;
    nd1 := nd1.GetNext;
    for I := 0 to chrtV.AxisList[N].Marks.Stripes.Styles.Count - 1 do
    begin
      nd1.Text := IntToStr(I) + ' - ' +
        chrtV.AxisList[N].Marks.Stripes.Styles[I].DisplayName;
      nd1 := nd1.GetNext;
    end;
  end
  else
  begin
   chrtV.AxisList[N].Marks.Stripes.Free;
   chrtV.AxisList[N].Marks.Stripes := nil;
  end;
end;

procedure TfrxChartEditorForm.FillDropDownLists(ds: TfrxDataset);
var
  I:Integer;
begin
  if ds = nil then
  begin
    sgData.Columns[1].PickList.Text := '';
  end
  else
  begin
    ds.GetFieldList(sgData.Columns[1].PickList);
    for i := 0 to  sgData.Columns[1].PickList.Count -1 do
      sgData.Columns[1].PickList[i] :=
        FReport.GetAlias(ds) + '."' + sgData.Columns[1].PickList[i] +'"';
  end;
end;

procedure TfrxChartEditorForm.InitGridData;

  procedure SetGrid;
  begin
    sgData.AutoFillColumns := False;
    sgData.FixedCols := 0;
    sgData.FixedRows := 0;
    sgData.Columns.Clear;
    sgData.RowCount := 2;
    sgData.DefaultColWidth := 32;
    sgData.PopupMenu := nil;
    sgData.OnButtonClick := nil;
    sgData.OnDrawCell := nil;
    sgData.OnPrepareCanvas := nil;

    case FTLS.FDataType of
      dtDBData: begin
        sgData.DefaultColWidth := 64;
        sgData.RowCount := 4;
        sgData.FixedRows := 0;
        with sgData.Columns.Add do
        begin
          SizePriority := 0;
          Font.Style:= [fsBold] ;
          ReadOnly := True;
        end;
        sgData.FixedCols := 0;
        sgData.Cells[0,0] := 'X';
        sgData.Cells[0,1] := 'Y';
        sgData.Cells[0,2] := 'Color';
        sgData.Cells[0,3] := 'Text';

        sgData.Columns.Add
      end;

      dtFixedData: begin
        sgData.DefaultColWidth := 32;
        sgData.RowCount := 2;
        with sgData.Columns.Add do
        begin
          Title.Font.Style := [fsBold];
          Title.Alignment := taCenter;
          Title.Caption := 'X';
        end;
        with sgData.Columns.Add do
        begin
          Assign(sgData.Columns[0]);
          Title.Caption := 'Y';
        end;
        with sgData.Columns.Add do
        begin
          Assign(sgData.Columns[0]);
          Title.Caption := 'Color';
          ButtonStyle := cbsEllipsis;
        end;
        with sgData.Columns.Add do
        begin
          Assign(sgData.Columns[0]);
          Title.Caption := 'Text';
        end;
        sgData.PopupMenu := pmRows;
        sgData.OnButtonClick := sgDataButtonClick;
        sgData.OnDrawCell := sgDataDrawCell;
        sgData.OnPrepareCanvas := sgDataPrepareCanvas;
        sgData.Options := SgData.Options + [goFixedRowNumbering, goAutoAddRows];
        sgData.FixedCols := 1;
        sgData.FixedRows := 1;
      end;
    end;
    sgData.Options := SgData.Options +
      [goAlwaysShowEditor,goEditing,goColSizing];
    sgData.AutoFillColumns := True;
  end;

var
  I:Integer;
begin
  if FTLS = nil then
    Exit;
  SetGrid;

  case FTLS.FDataType of
    dtDBData, dtBandData:begin
      while FDSPoints.Count - 3 > FLS.YCount do
        FDSPoints.Delete(FDSPoints.Count - 3);
      for I := 1 to FLS.YCount - 1 do
        sgData.InsertRowWithValues(I + 1,['Y' + IntToStr(I)]);
      for I := 0 to FDSPoints.Count - 1 do
        sgData.Cols[1][I] := FDSPoints[I];
    end;
    dtFixedData: begin
      sgData.RowCount := Max(FDataPoints.Count + 1, 2);
      for I := sgData.Columns.Count - 1 downto 0 do
        with sgData.Columns[I].Title do
          if (Caption[1] = 'Y') and (Caption <> 'Y') then
            sgData.Columns.Delete(I);
      for I := 2 to FLS.YCount do begin
        with sgData.Columns.Add do begin
          Assign(sgData.Columns[1]);
          Title.Caption := 'Y' + IntToStr(I);
          Index := I;
        end;
      end;
      for I := 0 to FDataPoints.Count - 1 do
        Split('|' + FDataPoints[I], sgData.Rows[I + 1]);
    end;
  end;
  spnY.Value := FLS.YCount;
  chkSort.Checked := FLS.Sorted;
end;

function TfrxChartEditorForm.ExtractGridData: Boolean;
var
  i: Integer;
  s: String;
  oldDataPoints: String;
begin
  case FTLS.FDataType of
    dtDBData, dtBandData: begin
      oldDataPoints := FDSPoints.Text;
      FDSPoints.Clear;
      for i := 0 to sgData.Cols[1].Count - 1 do
      begin
        if (i = sgData.Cols[1].Count - 1) and (sgData.Cols[1][i] = '') then
          sgData.Cols[1][i] := ' ';
        FDSPoints.Add(sgData.Cols[1][i]);
      end;
      Result := FDSPoints.Text <> oldDataPoints;
    end;
    dtFixedData:begin
      oldDataPoints := FDataPoints.Text;
      FDataPoints.BeginUpdate;
      try
        FDataPoints.Clear;
        for i := 1 to sgData.RowCount - 1 do
        begin
          with sgData.Rows[i] do begin
            Delimiter := '|';
            StrictDelimiter := true;
            s := DelimitedText;
          end;
          if Length(s) >= sgData.ColCount then
            FDataPoints.Add(Copy(s, 2, MaxInt));
        end;
      finally
        FDataPoints.EndUpdate;
       Result := FDataPoints.Text <> oldDataPoints;
      end;
    end;
  end;
end;

procedure TfrxChartEditorForm.SaveStyles;
var
  s,s1: string;
  I, J: Integer;
  Cs: TChartSeries;
  St: TChartStyle;
begin
  Chart.StyData.Clear;
  for I := 0 to chrtV.AxisList.Count - 1 do
  begin
    if chrtV.AxisList[I].Marks.Stripes <> nil then
    begin
      for J := 0 to chrtV.AxisList[I].Marks.Stripes.Styles.Count - 1 do
      begin
        s := IntToStr(I) + '+' + IntToStr(J);
        St := TChartStyle(chrtV.AxisList[I].Marks.Stripes.Styles[J]);
        with Chart.StyData.Add do
        begin
          Brush.Assign(St.Brush);
          Font.Assign(St.Font);
          Pen.Assign(St.Pen);
          RepeatCount := St.RepeatCount;
          Text := St.Text;
          UseBrush := St.UseBrush;
          UseFont := St.UseFont;
          UsePen := St.UsePen;
          NmSer := s;
        end;
      end;
    end;
  end;

  for I := 0 to chrtV.Series.Count - 1 do
  begin
    if chrtV.Series[I] is TChartSeries then
    begin
      Cs := TChartSeries(chrtV.Series[I]);
      s := Cs.Name;
      if (THackSeries(Cs).Styles <> nil) and
        (THackSeries(Cs).Styles.Styles.Count > 0) then
      begin
        for J := 0 to THackSeries(Cs).Styles.Styles.Count - 1 do
        begin
          s1 := s + '+' + IntToStr(J);
          St := TChartStyle(THackSeries(Cs).Styles.Styles[J]);
          with Chart.StyData.Add do
          begin
            Brush.Assign(St.Brush);
            Font.Assign(St.Font);
            Pen.Assign(St.Pen);
            RepeatCount := St.RepeatCount;
            Text := St.Text;
            UseBrush := St.UseBrush;
            UseFont := St.UseFont;
            UsePen := St.UsePen;
            NmSer := s1;
          end;
        end;
      end;
    end;
  end;
end;

procedure TfrxChartEditorForm.SaveTrans;
var
  I, J: Integer;
  tr: TAxisTransform;
begin
  Chart.TransData.Clear;
  for I := 0 to chrtV.AxisList.Count - 1 do
  begin
    if chrtV.AxisList[I].Transformations <> nil then
    for J := 0 to chrtV.AxisList[I].Transformations.List.Count - 1 do
    begin
      if TAxisTransform(chrtV.AxisList[I].Transformations.List.Items[J]) is TLinearAxisTransform then
      begin
        tr := TLinearAxisTransform(chrtV.AxisList[I].Transformations.List.Items[J]);
        with Chart.TransData.Add do
        begin
          Offset := TLinearAxisTransform(tr).Offset;
          Scale :=  TLinearAxisTransform(tr).Scale;
          Enabled := tr.Enabled;
          NameTr := IntToStr(I) + '+' + IntToStr(J) + '-' + '1';
        end;
      end;
      if TAxisTransform(chrtV.AxisList[I].Transformations.List.Items[J]) is TAutoScaleAxisTransform then
      begin
        tr := TAutoScaleAxisTransform(chrtV.AxisList[I].Transformations.List.Items[J]);
        with Chart.TransData.Add do
        begin
          MaxValue := TAutoScaleAxisTransform(tr).MaxValue;
          MinValue :=  TAutoScaleAxisTransform(tr).MinValue;
          Enabled := tr.Enabled;
          NameTr := IntToStr(I) + '+' + IntToStr(J) + '-' + '2';
        end;
      end;
      if TAxisTransform(chrtV.AxisList[I].Transformations.List.Items[J]) is TLogarithmAxisTransform then
      begin
        tr := TLogarithmAxisTransform(chrtV.AxisList[I].Transformations.List.Items[J]);
        with Chart.TransData.Add do
        begin
          Base := TLogarithmAxisTransform(tr).Base;
          Enabled := tr.Enabled;
          NameTr := IntToStr(I) + '+' + IntToStr(J) + '-' + '3';
        end;
      end;
      if TAxisTransform(chrtV.AxisList[I].Transformations.List.Items[J]) is TCumulNormDistrAxisTransform then
      begin
        tr := TCumulNormDistrAxisTransform(chrtV.AxisList[I].Transformations.List.Items[J]);
        with Chart.TransData.Add do
        begin
          //Base := TLogarithmAxisTransform(tr).Base;
          Enabled := tr.Enabled;
          NameTr := IntToStr(I) + '+' + IntToStr(J) + '-' + '4';
        end;
      end;
    end;
  end;
end;

procedure TfrxChartEditorForm.SaveLS;
var
  I: Integer;
  nd: TTreeNode;
  Obj: TLS;
  Ls : TListChartSource;
  s: string;
begin
  Chart.LSData.Clear;
  for I := 0 to chrtV.AxisList.Count - 1 do
  begin
    Obj := nil;
    if chrtV.AxisList[I].Marks.Source <> nil then
    begin
      if chrtV.AxisList[I].Marks.Source is TListChartSource then
      begin
        nd := trvChart.Items.GetFirstNode;
        nd := nd.GetFirstChild;
        nd := nd.GetFirstChild;
        while StrToInt(LeftStr(nd.Text, Pos(' -', nd.Text) - 1)) <> I do
          nd := nd.GetNextSibling;
        nd := nd.GetNext;
        nd := nd.GetNext;
        Obj := TLS(nd.Data);
      end;
      with Chart.LSData.Add do
      begin
        if chrtV.AxisList[I].Marks.Source is TListChartSource then
        begin
          Ls := TListChartSource(chrtV.AxisList[I].Marks.Source);
          DP.Assign(Ls.DataPoints);
          YCount := Ls.YCount;
          Sorted := Ls.Sorted;
          DataSet := Obj.FDataSet;
          DDP.Assign(Obj.FDSPoints);
          DataType := Obj.FDataType;
          TypeAS := 1;
        end
        else
        begin
          Params.Assign(TDateTimeIntervalChartSource(chrtV.AxisList[I].Marks.Source).Params);
          DateTimeFormat :=
            TDateTimeIntervalChartSource(chrtV.AxisList[I].Marks.Source).DateTimeFormat;
          Steps :=
            TDateTimeIntervalChartSource(chrtV.AxisList[I].Marks.Source).Steps;
          SuppressPrevUnit :=
            TDateTimeIntervalChartSource(chrtV.AxisList[I].Marks.Source).SuppressPrevUnit;
          TypeAS := 2;
        end;
        NameAS := IntToStr(I);
      end;
    end;
  end;
  for I := 0 to chrtV.Series.Count - 1 do
  begin
    s := chrtV.Series[I].Name;
    if chrtV.Series[I] is TChartSeries then
    begin
      nd := trvChart.Items.GetFirstNode;
      nd := nd.GetNextSibling;
      nd := nd.GetNext;
      while Pos(s, nd.Text) < 1 do
        nd := nd.GetNextSibling;
      Ls := TListChartSource(TChartSeries(chrtV.Series[I]).Source);
      obj := TLS(nd.Data);
      with Chart.LSData.Add do
      begin
        DP.Assign(Ls.DataPoints);
        DDP.Assign(Obj.FDSPoints);
        YCount := Ls.YCount;
        Sorted := Ls.Sorted;
        DataSet := Obj.FDataSet;
        DataType := Obj.FDataType;
        NameAS := s;
      end;
    end;
  end;
end;

procedure TfrxChartEditorForm.ClearLS;
var
  I: Integer;
  custs: TCustomChartSource;
  Cs: TChartStyles;
begin
  for I := 0 to chrtV.AxisList.Count - 1 do
  begin
    if chrtV.AxisList[I].Marks.Source <> nil then
    begin
      custs := chrtV.AxisList[I].Marks.Source;
      chrtV.AxisList[I].Marks.Source := nil;
      custs.Free;
    end;
  end;

  for I := 0 to chrtV.Series.Count - 1 do
  begin
    if (chrtV.Series[I] is TChartSeries) and
        (TChartSeries(chrtV.Series[I]).Source <> nil) then
    begin
      TChartSeries(chrtV.Series[I]).Source.Free;
      TChartSeries(chrtV.Series[I]).Source := nil;
      if THackSeries(chrtV.Series[I]).Styles <> nil then
      begin
        Cs := THackSeries(chrtV.Series[I]).Styles;
        Cs.Styles.Clear;
        THackSeries(chrtV.Series[I]).Styles := nil;
        Cs.Free;
      end;
    end;
  end;
end;

procedure TfrxChartEditorForm.ClearTrans;
var
  I, J: Integer;
  tr: TAxisTransform;
begin
  for I := 0 to chrtV.AxisList.Count - 1 do
  begin
    if chrtV.AxisList[I].Transformations <> nil then
    begin
      for J := chrtV.AxisList[I].Transformations.List.Count - 1 downto 0 do
      begin
        tr := TAxisTransform(chrtV.AxisList[I].Transformations.List[J]);
        chrtV.AxisList[I].Transformations.List.Delete(J);
        tr.Free;
      end;
      chrtV.AxisList[I].Transformations.Free;
      chrtV.AxisList[I].Transformations := nil;
    end;
  end;
end;

procedure TfrxChartEditorForm.ClearStripe;
var
  I: Integer;
begin
  for I := 0 to chrtV.AxisList.Count - 1 do
  begin
    if chrtV.AxisList[I].Marks.Stripes <> nil then
    begin
      chrtV.AxisList[I].Marks.Stripes.Styles.Clear;
      chrtV.AxisList[I].Marks.Stripes.Free;
      chrtV.AxisList[I].Marks.Stripes := nil;
    end;
  end;

end;




constructor TfrxChartEditorForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FReport := TfrxCustomDesigner(AOwner).Report;
  FDesigner := TfrxCustomDesigner(AOwner);
  FChart := TfrxChartView.Create(FReport);
  FInspector := TfrxObjectInspector.Create(Owner);
  with FInspector do
  begin
    SplitterPos := pnlLB.Width div 2;
    Box.Parent := pnlLB;
    Box.Align := alClient;
  end;
  OnMouseWheelDown := FInspector.FormMouseWheelDown;
  OnMouseWheelUp := FInspector.FormMouseWheelUp;
  FInspector.OnModify := ModifyInsp;
  tbSeries.Enabled := False;
end;

destructor TfrxChartEditorForm.Destroy;
begin
  FChart.Free;
  inherited Destroy;
end;


{ TfrxChartEditor }

function TfrxChartEditor.Edit: Boolean;
begin
  Result := False;
  if TfrxChartView(Component).IsDraw then
  with TfrxChartEditorForm.Create(Designer) do
  begin
    Chart.Assign(TfrxChartView(Component));
    Result := ShowModal = mrOk;
    if Result then
      TfrxChartView(Component).Assign(Chart);
    Free;
  end;
end;

function TfrxChartEditor.HasEditor: Boolean;
begin
  Result := True;
end;

procedure TfrxChartEditor.GetMenuItems;
var
  v: TfrxChartView;
begin
  v := TfrxChartView(Component);
  AddItem(frxResources.Get('mvHyperlink'), 50);
  AddItem('-', -1);
  AddItem(frxResources.Get('chAxis'), 2, v.Chart.AxisVisible);
  inherited;
end;

function TfrxChartEditor.Execute(Tag: Integer; Checked: Boolean): Boolean;
var
  i: Integer;
  c: TfrxComponent;
  v: TfrxChartView;
begin
  Result := inherited Execute(Tag, Checked);
  for i := 0 to Designer.SelectedObjects.Count - 1 do
  begin
    c := Designer.SelectedObjects[i];
    if (c is TfrxChartView) and not (rfDontModify in c.Restrictions) then
    begin
      v := TfrxChartView(c);
      if Tag = 2 then
        v.Chart.AxisVisible := Checked;
      Result := True;
    end;
  end;
end;

initialization

frxComponentEditors.Register(TfrxChartView, TfrxChartEditor);
frxHideProperties(TChart,'Name;Top;Left;Width;Height;AxisList;Series;GUIConnector;' +
'PopupMenu;Toolset');
frxHideProperties(TChartAxis,'Minors');
frxHideProperties(TChartAxisMarks,'Source;Stripes');
frxHideProperties(TBasicChartSeries, 'Name');

end.

