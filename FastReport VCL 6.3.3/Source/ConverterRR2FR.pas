
{******************************************}
{                                          }
{             FastReport v5.0              }
{         RaveReport -> FastReport         }
{                                          }
{         Copyright (c) 1998-2010          }
{          by Anton Khayrudinov            }
{            Fast Reports Inc.             }
{                                          }
{******************************************}

unit ConverterRR2FR;

interface

uses

  { Delphi }

  Classes,
  SysUtils,
  Graphics,
  Printers,
  Forms,
  FileCtrl,
  Dialogs,
  StdCtrls,
  Controls,
  ComCtrls,

  { FastReport }

  frxClass,
  frxBarCode,
  frxBarcod,
  frxADOComponents,
  frxBDEComponents,
  frxDBXComponents,
  frxIBXComponents,
  frxCustomDB,

  { RaveReport }

  RpDefine,
  RpRave,
  RpBase,
  RpSystem,
  RpBars,
  RvClass,
  RvProj,
  RvCsRpt,
  RvDefine,
  RvCsStd,
  RvCsBars,
  RvCsDraw,
  RvCsData,
  RvDatabase,
  RvDriverDataView;

type

  TRaveLoaderForm = class(TForm)

    lbTop: TLabel;
    pb: TProgressBar;
    bt: TButton;
    lbBottom: TLabel;

    procedure btClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);

  private

    FRunning: Boolean;
    FPage: string;
    FReport: string;



    procedure Stop;
    procedure UpdateLabel;
    procedure SetReport(const s: string);
    procedure SetPage(const s: string);
    procedure SetItemsCount(n: Integer);
    procedure SetComponentName(const s: string);
    function IsRunning: Boolean;

  public

    property Report: string write SetReport;
    property Page: string write SetPage;
    property Component: string write SetComponentName;
    property ItemsCount: Integer write SetItemsCount;

    { It's true if a user hasn't pressed the 'Cancel' button. }

    property Running: Boolean read IsRunning;

    { It's called when an item has been processed. }

    procedure NextItem;

    procedure Reset;

  end;

  { This function accepts two components:

      rc    Some Rave component that need be converted to an FR component.
      fc    Some FR component that's currently the parent. For example,
            fc can be a TfrxPage and then the function must create an FR component
            that'll be a child of fc and will be an FR analogue of rc.

    The function creates an FR analogue of rc Rave's component,
    adds this component to children of fc and returns the created component. }

  TRaveAddComponent = function(rc: TRaveComponent; fc: TfrxComponent):
    TfrxComponent of object;

  { This class contains Load function that loads a Rave report into FR.
    This Load function is needed for FR importing subsystem. }

  TRaveLoader = class(TObject)

    FOnUnknownComponent: TRaveAddComponent;
    FForm: TRaveLoaderForm;
    FLoadQueries: Boolean;
    FIsFirstBand: Boolean;
    FBandPos: real;

    { Converts the given Rave component to an FR component and
      does the same thing for all its children. }

    procedure EnumComponents(rc: TRaveComponent; fc: TfrxComponent);

    function HAlign(pj: TPrintJustify): TfrxHAlign;
    function FrameStyle(ps: TPenStyle): TfrxFrameStyle;

    { Rave designer allows to set the color of the brush fill pattern,
      but FR designer doesn't allow that. All brush fills will be black. }

    function BrushStyle(fs: TRaveFillStyle): TBrushStyle;

    procedure AssignBounds(rc: TRaveControl; fc: TfrxComponent);
    procedure AssignStyle(rc: TRaveSurface; fc: TfrxView);

    { Routine AddXXX(rc, fc) creates an FR equivalent of the given Rave rc
      component and makes the created component a child of the given FR fc
      component. If rc is a container, then the routine returns the newly
      created FR component. Otherwise, the routine returns fc. }

    function AddPage(rc: TRavePage; fc: TfrxComponent): TfrxComponent;
    function AddMemo(rc: TRaveMemo; fc: TfrxComponent): TfrxComponent;
    function AddText(rc: TRaveText; fc: TfrxComponent): TfrxComponent;
    function AddCustomText(rc: TRaveCustomText; fc: TfrxComponent): TfrxComponent;
    function AddRect(rc: TRaveRectangle; fc: TfrxComponent): TfrxComponent;
    function AddEllipse(rc: TRaveEllipse; fc: TfrxComponent): TfrxComponent;
    function AddBarCode(rc: TRaveBaseBarCode; fc: TfrxComponent): TfrxComponent;
    function AddImage(rc: TRaveGraphicImage; fc: TfrxComponent): TfrxComponent;
    function AddDataBand(rc: TRaveDataBand; fc: TfrxComponent): TfrxComponent;
    function AddBand(rc: TRaveBand; fc: TfrxComponent): TfrxComponent;
    function AddRegion(rc: TRaveRegion; fc: TfrxComponent): TfrxComponent;
    function AddDatabase(rc: TRaveDatabase; fc: TfrxComponent): TfrxComponent;
    function AddDataview(rc: TRaveDriverDataView; fc: TfrxComponent): TfrxComponent;
    function AddStub(rc: TRaveControl; fc: TfrxComponent): TfrxComponent;
    function AddUnknown(rc: TRaveComponent; fc: TfrxComponent): TfrxComponent;

    { There's a bug in Rave v5.0 - it doesn't save the style of lines to .rav files. }

    function AddLine(rc: TRaveLine; fc: TfrxComponent): TfrxComponent;

    { Returns the Tag of the component if it's not nil,
      or returns the default value if it's nil. }

    function GetTag(c: TComponent; default: Integer = 0): Integer;

    { Every string from a Rave report goes through this function (String Gate).
      This function simply returns its result. }

    function SG(const s: string): string; inline;

  public

    constructor Create;
    destructor Destroy; override;

    function Load(Report: TfrxReport; Stream: TStream): Boolean;

    { While analysing a Rave report, the import may find a component that
      is unknown to it. In this case it can call a handler for this situation. }

    property OnUnknownComponent: TRaveAddComponent
      read FOnUnknownComponent write FOnUnknownComponent;

    { Specifies whether to load SQL queries or not.
      By default this option is disabled, since some Rave builds corrupts
      memory while processing queries. }

    property LoadQueries: Boolean read FLoadQueries write FLoadQueries; {default False}

  end;

{ Rave classes hierarchy:

  TComponent - belongs to VCL
    TRaveComponent
      TRaveDataField
        TRaveStringField
        TRaveDateTimeField
        TRaveFloatField
        TRaveFormattedField
          TRaveIntegerField

      TRaveContainerComponent
        TRaveProjectItem
          TRavePage
          TRaveReport
          TRaveDataObject
            TRaveDatabase
            TRaveBaseDataView
              TRaveDriverDataView

          TRaveProjectManager

      TRaveControl
        TRaveBaseImage
          TRaveGraphicImage
            TRaveBitmap
            TRaveMetafile

        TRaveContainerControl
          TRaveBand
            TRaveIterateBand
              TRaveDataBand

          TRaveRegion
          TRaveSection
            TRaveDataMirrorSection

        TRaveBaseBarCode
        TRaveCustomText
          TRaveText
            TRaveDataText
            TRaveCalcText

          TRaveMemo
            TRaveDataMemo

        TRaveGraphicBase
          TRaveLine
            TRaveHLine
            TRaveVLine

          TRaveSurface
            TRaveRectangle
              TRaveSquare

            TRaveEllipse
              TRaveCircle
}

{ This routine adds to FR the ability to open rav files.
  After the returned TRaveLoader is no longer needed,
  it must be deleted by its Free method. }

function RegisterLoader: TRaveLoader;

implementation

{$R *.dfm}

uses
  frxRes;

var
  Loader: TRaveLoader;

function ResStr(const Index: string): string;
begin
  Result := frxResources.Get(Index);
end;

function RegisterLoader: TRaveLoader;
begin
  Result := TRaveLoader.Create;
  frxFR2Events.OnLoad := Result.Load;
  frxFR2Events.Filter := '*.rav';
end;

{ TRaveLoader }

constructor TRaveLoader.Create;
begin
  FForm := TRaveLoaderForm.Create(nil);
  FLoadQueries := False;
end;

destructor TRaveLoader.Destroy;
begin
  FForm.Free;
end;

function TRaveLoader.AddDataBand(rc: TRaveDataBand; fc: TfrxComponent): TfrxComponent;
var
  b: TfrxDataBand;
begin
  if rc.ControllerBand <> nil then
    b := TfrxDetailData.Create(fc)
  else
    b := TfrxMasterData.Create(fc);
  AssignBounds(rc, b);
  b.CreateUniqueName;
  b.DataSet := TfrxDataSet(GetTag(rc.DataView));
  if (b.DataSet = nil) and (rc.DataView <> nil) then
    b.DataSetName := rc.DataView.Name;

  FIsFirstBand := False;
  rc.Top := FBandPos;
  b.Top := FBandPos;
  FBandPos := FBandPos + rc.Height;
  Result := b;
end;

function TRaveLoader.AddBand(rc: TRaveBand; fc: TfrxComponent): TfrxComponent;
var
  b: TfrxBand;
begin
  b := nil;
  if FIsFirstBand and ((TBandPrintLoc.plBodyHeader in rc.ReprintLocs) or (TBandPrintLoc.plRowHeader in rc.ReprintLocs) or (TBandPrintLoc.plGroupHeader in rc.ReprintLocs)) then
    b := TfrxReportTitle.Create(fc);

  if b = nil then
  begin
  if rc.ControllerBand <> nil then
  begin
    if (rc.ControllerBand.Top > FBandPos) or (rc.ControllerBand.Top = 0) then
      rc.ReprintLocs := rc.ReprintLocs - [TBandPrintLoc.plBodyFooter, TBandPrintLoc.plRowFooter, TBandPrintLoc.plGroupFooter];
  end;
  if (TBandPrintLoc.plBodyFooter in rc.ReprintLocs) or (TBandPrintLoc.plRowFooter in rc.ReprintLocs) then
    b := TfrxFooter.Create(fc)
  else if (TBandPrintLoc.plGroupFooter in rc.ReprintLocs) then
    b := TfrxGroupFooter.Create(fc)
  else if (TBandPrintLoc.plBodyHeader in rc.ReprintLocs) or (TBandPrintLoc.plRowHeader in rc.ReprintLocs) then
    b := TfrxHeader.Create(fc)
  else if (TBandPrintLoc.plGroupHeader in rc.ReprintLocs) then
    b := TfrxGroupHeader.Create(fc)
  else if (TBandPrintLoc.plDetail in rc.ReprintLocs) then
    b := TfrxDetailData.Create(fc)
  else if (TBandPrintLoc.plMaster in rc.ReprintLocs) then
    b := TfrxMasterData.Create(fc)
  else
    b := TfrxBand.Create(fc);
  end;
  AssignBounds(rc, b);
  b.CreateUniqueName;
  FIsFirstBand := False;
  rc.Top := FBandPos;
  b.Top := FBandPos;
  FBandPos := FBandPos + rc.Height;
  Result := b;
end;

function TRaveLoader.AddDatabase(rc: TRaveDatabase; fc: TfrxComponent): TfrxComponent;
var
  db: TfrxCustomDatabase;
  link: string;
begin
  link := SG(rc.LinkType);
  db := nil;

  { It's possible that one of these constructors will raise
    an exception. For instance, if ibnstall.dll doesn't exist
    and there's an attempt to create an IBX database. }

  try
    if link = 'ADO' then
      db := TfrxADODatabase.Create(fc)
    else if link = 'BDE' then
      db := TfrxBDEDatabase.Create(fc)
    else if link = 'DBX' then
      db := TfrxDBXDatabase.Create(fc)
    else if link = 'IBX' then
      db := TfrxIBXDatabase.Create(fc);
  except
  end;

  if db = nil then
  begin
    Result := AddUnknown(rc, fc);
    Exit;
  end;

  { Path to a database may be incorrect
    when loading the report on another system. }

  db.DatabaseName := SG(rc.AuthRun.DataSource);
  db.LoginPrompt := False;
  db.CreateUniqueName;
  rc.Tag := frxInteger(db);
  Result := fc;
end;

function TRaveLoader.AddStub(rc: TRaveControl; fc: TfrxComponent): TfrxComponent;
var
  m: TfrxMemoView;
begin
  m := TfrxMemoView.Create(fc);
  m.CreateUniqueName;
  m.Text := SG(rc.Name) + ':' + SG(rc.ClassName);
  m.Frame.Width := 1;
  m.Frame.Typ := [ftLeft, ftRight, ftTop, ftBottom];
  AssignBounds(rc, m);
  Result := m;
end;

function TRaveLoader.AddDataview(rc: TRaveDriverDataView; fc: TfrxComponent): TfrxComponent;

  function CreateADOQuery: TfrxADOQuery;
  var
    q: TfrxADOQuery;
  begin
    q := TfrxADOQuery.Create(fc);
    q.Database := TfrxADODatabase(GetTag(rc.Database));
    q.Query.SQL.Add(SG(rc.Query));
    Result := q;
  end;

  function CreateBDEQuery: TfrxBDEQuery;
  var
    q: TfrxBDEQuery;
  begin
    q := TfrxBDEQuery.Create(fc);
    q.Query.SQL.Add(SG(rc.Query));
    Result := q;

    if rc.Database = nil then
      q.DatabaseName := ''
    else
      q.DatabaseName := TfrxBDEDatabase(rc.Database.Tag).DatabaseName;
  end;

  function CreateDBXQuery: TfrxDBXQuery;
  var
    q: TfrxDBXQuery;
  begin
    q := TfrxDBXQuery.Create(fc);
    q.Database := TfrxDBXDatabase(GetTag(rc.Database));
    q.Query.SQL.Add(SG(rc.Query));
    Result := q;
  end;

  function CreateIBXQuery: TfrxIBXQuery;
  var
    q: TfrxIBXQuery;
  begin
    q := TfrxIBXQuery.Create(fc);
    q.Database := TfrxIBXDatabase(GetTag(rc.Database));
    q.Query.SQL.Add(SG(rc.Query));
    Result := q;
  end;

var
  s: TfrxDataSet;
  link: string;
begin
  if rc.Database = nil then
    link := ''
  else
    link := SG(rc.Database.LinkType);

  s := nil;

  if LoadQueries then
  try
    if link = 'ADO' then
      s := CreateADOQuery
    else if link = 'BDE' then
      s := CreateBDEQuery
    else if link = 'DBX' then
      s := CreateDBXQuery
    else if link = 'IBX' then
      s := CreateIBXQuery;
  except
  end;

  if s = nil then
  begin
    Result := AddUnknown(rc, fc);
    Exit;
  end;

  s.CreateUniqueName;
  fc.Report.DataSets.Add(s);
  rc.Tag := frxInteger(s);
  Result := fc;
end;

function TRaveLoader.AddBarCode(rc: TRaveBaseBarCode; fc: TfrxComponent): TfrxComponent;
var
  b: TfrxBarCodeView;
begin
  b := TfrxBarCodeView.Create(fc);
  b.CreateUniqueName;

  if rc is TRavePostNetBarCode then
    b.BarType := bcCodePostNet
  else if rc is TRaveI2of5BarCode then
    b.BarType := bcCode_2_5_interleaved
  else if rc is TRaveCode39BarCode then
    b.BarType := bcCode39
  else if rc is TRaveCode128BarCode then
    b.BarType := bcCode128A
  else if rc is TRaveUPCBarCode then
    b.BarType := bcCodeUPC_A
  else if rc is TRaveEANBarCode then
    b.BarType := bcCodeEAN13
  else
    b.BarType := bcCodeMSI;

  b.Text := SG(rc.Text);
  b.ShowText := False;
  AssignBounds(rc, b);
  Result := b;
end;

function TRaveLoader.AddPage(rc: TRavePage; fc: TfrxComponent): TfrxComponent;
var
  p: TfrxReportPage;
begin
  p := TfrxReportPage.Create(fc);
  p.CreateUniqueName;
  p.SetDefaults;
  FIsFirstBand := True;
  FBandPos := 0;
  p.LeftMargin := 0;
  p.RightMargin := 0;
  p.TopMargin := 0;
  p.BottomMargin := 0;

  if rc.Orientation = poLandScape then
    p.Orientation := TPrinterOrientation.poLandscape
  else
    p.Orientation := TPrinterOrientation.poPortrait;

  p.PaperWidth := rc.PageWidth * 25.4;
  p.PaperHeight := rc.PageHeight * 25.4;
  Result := p;
end;

function TRaveLoader.AddCustomText(rc: TRaveCustomText; fc: TfrxComponent): TfrxComponent;

  function IsWord(s: WideString): Boolean;
  var
    i: Integer;
  begin
    for i := 1 to Length(s) do
      if not CharInSet(s[i], ['a'..'z', 'A'..'Z']) then
      begin
        Result := False;
        Exit;
      end;

    Result := True;
  end;

var
  m: TfrxMemoView;
  ds: TfrxDataSet;
  s: WideString;
  DSName: String;
begin
  m := TfrxMemoView.Create(fc);
  m.CreateUniqueName;
  m.Text := SG(rc.Text);
  m.Font.Assign(rc.Font);
  m.HAlign := HAlign(rc.FontJustify);
  AssignBounds(rc, m);

  ds := nil;
  DSName := '';

  if rc is TRaveDataText then
  begin
    ds := TfrxDataSet(GetTag(TRaveDataText(rc).DataView));
    if (ds = nil) and (TRaveDataText(rc).DataView <> nil) then
      DSName := TRaveDataText(rc).DataView.Name;
    if(TRaveDataText(rc).DataField <> '') then
      begin
        m.Text := Format('[%s."%s"]', [DSName, TRaveDataText(rc).DataField]);
        DSName := '';
        ds := nil;
      end;
  end
  else if rc is TRaveDataMemo then
  begin
    ds := TfrxDataSet(GetTag(TRaveDataMemo(rc).DataView));
    if (ds = nil) and (TRaveDataMemo(rc).DataView <> nil) then
      DSName := TRaveDataMemo(rc).DataView.Name;
    if(TRaveDataMemo(rc).DataField <> '') then
      begin
        m.Text := Format('[%s."%s"]', [DSName, TRaveDataMemo(rc).DataField]);
        DSName := '';
        ds := nil;
      end;
  end;


  if (ds <> nil) or (DSName <> '') then
  begin
    if ds <> nil then
      m.DataSet := ds
    else
      m.DataSetName := DSName;

    { Convert Rave datatext into FR datatext. }

    { todo -oDraeden: Rave datatext can be a simple table field from a dataview
      or an expression involving several table fields. This code processes
      only simple fields. }

    s := Trim(m.Text);

    if (Length(s) > 2) and (s[1] = '[') and (s[Length(s)] = ']') then
    begin
      s := Copy(s, 2, Length(s) - 2);

      if IsWord(s) then
        if ds <> nil then
          m.Text := Format('[%s."%s"]', [ds.UserName, s])
        else
          m.Text := Format('[%s."%s"]', [DSName, s])
    end;
  end;

  Result := m;
end;

function TRaveLoader.AddMemo(rc: TRaveMemo; fc: TfrxComponent): TfrxComponent;
begin
  Result := AddCustomText(rc, fc);
end;

function TRaveLoader.AddText(rc: TRaveText; fc: TfrxComponent): TfrxComponent;
begin
  Result := AddCustomText(rc, fc);
end;

function TRaveLoader.AddUnknown(rc: TRaveComponent; fc: TfrxComponent): TfrxComponent;
begin
  if not Assigned(OnUnknownComponent) then
  begin
    Result := fc;
    Exit;
  end;

  Result := OnUnknownComponent(rc, fc);

  if (Result = nil) or not (Result is TfrxComponent) then
    raise Exception.CreateFmt('%s.OnUnknownComponent returned a non-FR component',
      [ClassName]);
end;

function TRaveLoader.AddLine(rc: TRaveLine; fc: TfrxComponent): TfrxComponent;
var
  c: TfrxLineView;
begin
  c := TfrxLineView.Create(fc);
  c.CreateUniqueName;
  AssignBounds(rc, c);
  c.Diagonal := (rc.Width <> 0) or (rc.Height <> 0);
  c.Frame.Width := rc.LineWidth;
  c.Frame.Style := FrameStyle(rc.LineStyle);
  c.Frame.Color := rc.Color;
  Result := c;
end;

function TRaveLoader.AddRect(rc: TRaveRectangle; fc: TfrxComponent): TfrxComponent;
var
  r: TfrxShapeView;
begin
  r := TfrxShapeView.Create(fc);
  r.CreateUniqueName;
  r.Shape := skRectangle;
  AssignBounds(rc, r);
  AssignStyle(rc, r);
  Result := r;
end;

function TRaveLoader.AddRegion(rc: TRaveRegion; fc: TfrxComponent): TfrxComponent;
var
  s: TfrxSubreport;
  p: TfrxReportPage;
begin
  p := TfrxReportPage.Create(fc.Parent);
  p.CreateUniqueName;
  s := TfrxSubreport.Create(fc);
  s.CreateUniqueName;
  AssignBounds(rc, s);
  s.Page := p;
  Result := p;
end;

function TRaveLoader.AddEllipse(rc: TRaveEllipse; fc: TfrxComponent): TfrxComponent;
var
  r: TfrxShapeView;
begin
  r := TfrxShapeView.Create(fc);
  r.CreateUniqueName;
  r.Shape := skEllipse;
  AssignBounds(rc, r);
  AssignStyle(rc, r);
  Result := r;
end;

function TRaveLoader.AddImage(rc: TRaveGraphicImage; fc: TfrxComponent): TfrxComponent;
var
  p: TfrxPictureView;
begin
  p := TfrxPictureView.Create(fc);
  p.CreateUniqueName;
  AssignBounds(rc, p);

  if rc.Image <> nil then
    p.Picture.Assign(rc.Image);

  Result := p;
end;

procedure TRaveLoader.AssignBounds(rc: TRaveControl; fc: TfrxComponent);

  { Returns True if the Rave component is represented in FR
    as a container. This function is needed because some Rave
    containers, like Section, don't have any representation in FR. }

  function IsFRContainer(rc: TRaveComponent): Boolean;
  begin
    Result := (rc is TRavePage) or (rc is TRaveBand);
  end;

  { Converts a point in Rave coordinate system
    into a point in FR coordinate system. }

  function Pos(p: TfrxPoint): TfrxPoint;
  var
    c: TRaveComponent;
  begin
    c := rc.Parent;

    while (c <> nil) and (c is TRaveControl) and not IsFRContainer(c) do
    begin
      p.Y := p.Y + TRaveControl(c).Top;
      p.X := p.X + TRaveControl(c).Left;
      c := c.Parent;
    end;

    Result.X := p.X * 2.54 * fr1cm;
    Result.Y := p.Y * 2.54 * fr1cm;
  end;

var
  lt, rb: TfrxPoint;
begin
  lt.X := rc.Left;
  lt.Y := rc.Top;
  rb.X := rc.Right;
  rb.Y := rc.Bottom;

  lt := Pos(lt);
  rb := Pos(rb);

  fc.Left   := lt.X;
  fc.Top    := lt.Y;
  fc.Width  := rb.X - lt.X;
  fc.Height := rb.Y - lt.Y;
end;

procedure TRaveLoader.AssignStyle(rc: TRaveSurface; fc: TfrxView);
begin
  fc.Frame.Style := FrameStyle(rc.BorderStyle);
  fc.Frame.Width := rc.BorderWidth;
  fc.Frame.Color := rc.BorderColor;

  case rc.FillStyle of
    fsClear:
    begin
      fc.BrushStyle := bsSolid;
      fc.Color := clNone;
    end;

    fsSolid:
    begin
      fc.BrushStyle := bsSolid;
      fc.Color := rc.FillColor;
    end

    else
    begin
      fc.BrushStyle := BrushStyle(rc.FillStyle);
      fc.Color := clNone;
    end;
  end;

  if rc.BorderStyle = psClear then
    fc.Frame.Color := clNone
  else
    fc.Frame.Typ := [ftLeft, ftTop, ftRight, ftBottom];
end;

function TRaveLoader.HAlign(pj: TPrintJustify): TfrxHAlign;
begin
  case pj of
    pjCenter: Result := haCenter;
    pjLeft:   Result := haLeft;
    pjRight:  Result := haRight;
    pjBlock:  Result := haBlock;
    else      Result := haLeft;
  end;
end;

function TRaveLoader.BrushStyle(fs: TRaveFillStyle): TBrushStyle;
begin
  case fs of
    fsSolid:      Result := bsSolid;
    fsClear:      Result := bsClear;
    fsHorizontal: Result := bsHorizontal;
    fsVertical:   Result := bsVertical;
    fsFDiagonal:  Result := bsFDiagonal;
    fsBDiagonal:  Result := bsBDiagonal;
    fsCross:      Result := bsCross;
    fsDiagCross:  Result := bsDiagCross;
    fsNone:       Result := bsClear;
    else          Result := bsClear;
  end;
end;

function TRaveLoader.FrameStyle(ps: TPenStyle): TfrxFrameStyle;
begin
  case ps of
    psDash:       Result := TfrxFrameStyle.fsDash;
    psDot:        Result := TfrxFrameStyle.fsDot;
    psDashDot:    Result := TfrxFrameStyle.fsDashDot;
    psDashDotDot: Result := TfrxFrameStyle.fsDashDotDot;
    else          Result := TfrxFrameStyle.fsSolid;
  end;
end;

function TRaveLoader.GetTag(c: TComponent; default: Integer): Integer;
begin
  if c = nil then
    Result := default
  else
    Result := c.Tag;
end;

procedure TRaveLoader.EnumComponents(rc: TRaveComponent; fc: TfrxComponent);

  procedure EnumChildren;
  var
    i: Integer;
    bands, items: TList;
  begin
    bands := TList.Create;
    items := TList.Create;

    { All bands in Rave have the top coordinate Y = 0.
      This means that Rave bands must be traversed in the
      backward order, from the bottom-most to the top-most,
      so as bands will appear in FR in the same order as in Rave. }

    try
      with rc do
        for i := 0 to ChildCount - 1 do
          if Child[i] is TRaveBand then
            bands.Add(Child[i])
          else
            items.Add(Child[i]);

      for i := 0 to bands.Count - 1 do
        EnumComponents(bands[i], fc);

      for i := 0 to items.Count - 1 do
        EnumComponents(items[i], fc);
    finally
      items.Free;
      bands.Free;
    end;
  end;

begin
  if not FForm.Running then
    Exit;

  { Display on the form what component is being processed. }

  FForm.Component := SG(rc.Name) + ' : ' + SG(rc.ClassName);

  if rc is TRaveReport then
    FForm.Report := SG(rc.Name);

  if rc is TRavePage then
  begin
    FForm.Page := SG(rc.Name);
    FForm.NextItem;
  end;

  Application.ProcessMessages;

  { datamirror }

  if rc is TRaveDataMirrorSection then
    fc := AddStub(rc as TRaveControl, fc)

  { page }

  else if rc is TRavePage then
    fc := AddPage(rc as TRavePage, fc)

  { memo }

  else if rc is TRaveMemo then
    fc := AddMemo(rc as TRaveMemo, fc)

  { text }

  else if rc is TRaveText then
    fc := AddText(rc as TRaveText, fc)

  { rectangle }

  else if rc is TRaveRectangle then
    fc := AddRect(rc as TRaveRectangle, fc)

  { line }

  else if rc is TRaveLine then
    fc := AddLine(rc as TRaveLine, fc)

  { ellipse }

  else if rc is TRaveEllipse then
    fc := AddEllipse(rc as TRaveEllipse, fc)

  { barcode }

  else if rc is TRaveBaseBarCode then
    fc := AddBarCode(rc as TRaveBaseBarCode, fc)

  { picture }

  else if rc is TRaveGraphicImage then
    fc := AddImage(rc as TRaveGraphicImage, fc)

  { region }

  else if rc is TRaveRegion then
    fc := AddRegion(rc as TRaveRegion, fc)

  { databand }

  else if rc is TRaveDataBand then
    fc := AddDataBand(rc as TRaveDataBand, fc)

  { band }

  else if rc is TRaveBand then
    fc := AddBand(rc as TRaveBand, fc)

  { database }

  else if rc is TRaveDatabase then
    fc := AddDatabase(rc as TRaveDatabase, fc)

  { dataview }

  else if rc is TRaveDriverDataView then
    fc := AddDataview(rc as TRaveDriverDataView, fc)

  { unknown object }

  else
    fc := AddUnknown(rc, fc);

  { enumerate all children }

  EnumChildren;
end;

{ Rave file contains a tree of components arranged as following:

    TRaveProjectManager       The Rave file
      TRavePage               Global page #1 - it's shared between all other pages
      TRavePage               Global page #2 - it's shared between all other pages
      ...                     ...

      TRaveReport             Report #1 - it corresponds to one fr3 file
        TRavePage             Page #1
        TRavePage             Page #2
        ...                   ...

      TRaveReport             Report #2 - it corresponds to one fr3 file
        TRavePage             Page #1
        TRavePage             Page #2
        ...

      ... }

function TRaveLoader.Load(Report: TfrxReport; Stream: TStream): Boolean;

  function ReadStr(Stream: TStream; Count: Cardinal): AnsiString;
  var
    Pos: Int64;
  begin
    SetLength(Result, Count);
    Pos := Stream.Position;
    Stream.Read(Result[1], Count);
    Stream.Position := Pos;
  end;

  { Adds to FR a TRaveReport and a list of TRaveComponent items. }

  procedure EnumReport(rr: TRaveReport; gi: TList);
  var
    i: Integer;
  begin
    EnumComponents(rr, Report);

    i := 0;
    while (i < gi.Count) and FForm.Running do
    begin
      EnumComponents(TRaveComponent(gi[i]), Report);
      Inc(i);
    end;
  end;

var
  rvp: TRvProject;
  reports, items: TList;
  i, j, rn, pn: Integer;
  s: string;
begin
  if ReadStr(Stream, 3) <> 'RAV' then
  begin
    Result := False;
    Exit;
  end;

  rvp := TRvProject.Create(nil);
  reports := TList.Create;
  items := TList.Create;

  try
    FForm.Reset;

    { Some versions of Rave has TRvProject.LoadFromStream method
      that has a bug and corrupts memory. This may lead to TfrxReport's
      destruction. }

    rvp.LoadFromStream(Stream);

    { Separate TRaveReport objects from other stuff, like global pages.
      The stuff must be added to FR after reports. }

    with rvp.ProjMan do
      for i := 0 to ChildCount - 1 do
        if Child[i] is TRaveReport then
          reports.Add(Child[i])
        else
          items.Add(Child[i]);

    { Count the number of pages that will be added to FR.
      Some pages, like global pages, will be added several times. }

    pn := 0;

    for i := 0 to reports.Count - 1 do
    begin
      with TRaveReport(reports[i]) do
        for j := 0 to ChildCount - 1 do
          if Child[j] is TRavePage then
            Inc(pn);

      for j := 0 to items.Count - 1 do
        if TRaveComponent(items[j]) is TRavePage then
          Inc(pn);
    end;

    FForm.ItemsCount := pn;
    rn := reports.Count;

    if rn = 0 then
      raise Exception.Create(ResStr('rave1'));

    if rn = 1 then
    begin
      FForm.Show;
      Report.Clear;
      EnumReport(TRaveReport(reports[0]), items);
      Result := True;
    end
    else if not SelectDirectory(Format(ResStr('rave2'), [rn]), '', s, [sdNewUI, sdShowEdit]) then
      Result := True // the user cancels loading - return 'success' and exit
    else
    begin
      if not SysUtils.DirectoryExists(s) and not CreateDir(s) then
        raise EInOutError.Create(Format(ResStr('rave3'), [s]));

      FForm.Show;

      i := 0;
      while (i < rn) and FForm.Running do
      begin
        Report.Clear;
        EnumReport(TRaveReport(reports[i]), items);
        Report.SaveToFile(Format('%s\%d.fr3', [s, i + 1]));
        Inc(i);
      end;

      Result := True;
    end;
  except
    Result := False;
  end;

  FForm.Hide;
  items.Free;
  reports.Free;
  rvp.Free;
end;

function TRaveLoader.SG(const s: string): string;
begin
  Result := s;
end;

{ TRaveLoaderForm }

procedure TRaveLoaderForm.btClick(Sender: TObject);
begin
  Stop;
end;

procedure TRaveLoaderForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Stop;
end;

procedure TRaveLoaderForm.FormCreate(Sender: TObject);
begin
  Caption := ResStr('rave0');
  bt.Caption := 'Stop';
  {$IFDEF DELPHI24}
    ScaleForPPI(Screen.PixelsPerInch);
  {$ENDIF}
end;

function TRaveLoaderForm.IsRunning: Boolean;
begin
  Result := FRunning;
end;

procedure TRaveLoaderForm.NextItem;
begin
  pb.Position := pb.Position + 1;
end;

procedure TRaveLoaderForm.Reset;
begin
  FRunning := True;
  FPage := '';
  FReport := '';
  pb.Position := 0;
  lbTop.Caption := '';
  lbBottom.Caption := '';
  bt.Enabled := True;
end;

procedure TRaveLoaderForm.SetComponentName(const s: string);
begin
  lbBottom.Caption := s;
end;

procedure TRaveLoaderForm.SetItemsCount(n: Integer);
begin
  pb.Max := n;
end;

procedure TRaveLoaderForm.SetPage(const s: string);
begin
  FPage := s;
  UpdateLabel;
end;

procedure TRaveLoaderForm.SetReport(const s: string);
begin
  FReport := s;
  UpdateLabel;
end;

procedure TRaveLoaderForm.Stop;
begin
  FRunning := False;
  bt.Enabled := False;
end;

procedure TRaveLoaderForm.UpdateLabel;
begin
  lbTop.Caption := Format(ResStr('rave4'), [FReport, FPage]);
end;

initialization

Loader := RegisterLoader;

finalization

Loader.Free;

end.
