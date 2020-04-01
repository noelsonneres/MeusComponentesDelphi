
{******************************************}
{                                          }
{             FastReport v6.0              }
{                XLS export                }
{                                          }
{         Copyright (c) 1998-2017          }
{           by Anton Khayrudinov           }
{             Fast Reports Inc.            }
{                                          }
{******************************************}

{ This module contains a component that allows to
  export prepaired reports to Microsoft Excel 2003 files.
  These files consist of the following parts:

    - CBFF    - Base format. See frxCBFF.pas
    - BIFF    - Actual contents of sheets. See frxBIFF.pas
    - Escher  - Drawings and images. See frxEscher.pas
    - OLEPS   - Additional information. See frxOLEPS.pas
    - RC4     - Document encrypting. See frxCrypto.pas

  There's a bug or a feature in MS Excel that you should
  know if you want to make good xls files for printing. When
  exporting a report, there can be an object (picture, memo, etc.)
  close to a border of a report page, i.e. the distance between
  this object and a border of the page is zero or very small.
  When creating the appropriate xls file, this object will become
  a text cell or a picture that is aligned to a side of the print page.
  We assume that this object fits to the print page.
  MS Excel assumes that neighbouring cells of this object must be
  printed too, but they don't fit to the print page. There's no
  complete solution of this problem. Partial solutions are:

    - Do not place any objects close to a side of the page.
    - If you have to place object close to a side of the page,
      decrease the page margins. }
{$I frx.inc}
unit frxExportBIFF;

interface

uses
  Windows,
  SysUtils,
  Classes,
  ShellAPI,

  frxClass,
  frxExportMatrix,
  frxProgress,
  frxStorage,

  frxBIFF,
  frxOLEPS,
  frxEscher,
  frxDraftPool,
  frxBiffConverter,
  frxExportBaseDialog
{$IFDEF DELPHI16}
, System.UITypes
{$ENDIF}
;

type

  TfrxDraftSheet = class
  public
    Options: TfrxBiffPageOptions;
  end;

  { Export filter }

{$IFDEF DELPHI16}
[ComponentPlatformsAttribute(pidWin32 or pidWin64)]
{$ENDIF}
  TfrxBIFFExport = class(TfrxBaseDialogExportFilter)
  private
    FParallelPages:   LongInt;
    FProgress:        TfrxProgress;

    { The following fields control appearance
      of the generated xls file }

    FSingleSheet:     Boolean;
    FDeleteEmptyRows: Boolean;
    FChunkSize:       LongInt;
    FGridLines:       Boolean;
    FInaccuracy:      Extended;
    FFitPages:        Boolean;
    FPictures:        Boolean;
    FRowHeightScale:  Extended;
    FExportFormulas:  Boolean;

    { The following fields are used internally
      during generating the xls file }

    FMatrix:          TfrxIEMatrix;
    FWB:              TBiffWorkbook;
    FZCW:             LongInt;            // Width in points of '0' char of the 0-th font
    FTSW:             LongInt;            // Width of three blank characters
    FLastPage:        TfrxPageInfo;       // Last exported page
    FDraftPool:       TDpDraftPool;

    { The following fields specify additional
      information that is saved in the generated
      xls file }

    FAuthor:          AnsiString;
    FComment:         AnsiString;
    FKeywords:        AnsiString;
    FRevision:        AnsiString;
    FAppName:         AnsiString;
    FSubject:         AnsiString;
    FCategory:        AnsiString;
    FCompany:         AnsiString;
    FTitle:           AnsiString;
    FAccess:          TOlepsAccess;
    FManager:         AnsiString;

    { Document encryption }

    FPassword:        WideString;

    procedure SetChunkSize(Value: LongInt);
    procedure SetPassword(const s: WideString);
    procedure SetParallelPages(Count: LongInt);
    procedure SetRowHeightScale(Value: Extended);

    { Returns a partial filled structure containing
      options for exporting a matrix to a sheet. }

    function GetExportOptionsDraft: TfrxBiffPageOptions;

    { Workbook CBFF stream contents }

    procedure SaveWorkbook(s: TStream);

    { <05>SummaryInformation OLEPS stream contents }

    procedure SaveSI(s: TStream);

    { <05>DocumentSummaryInformation OLEPS stream contents }

    procedure SaveDSI(s: TStream);

    procedure InitProgressBar(Steps: Integer; Text: string);
    procedure StepProgressBar;
    procedure FreeProgressBar;

  public

    constructor Create(AOwner: TComponent); override;

    class function GetDescription: string; override;
    class function ExportDialogClass: TfrxBaseExportDialogClass; override;
    function Start: Boolean; override;
    procedure Finish; override;
    procedure FinishPage(Page: TfrxReportPage; Index: Integer); override;
    procedure StartPage(Page: TfrxReportPage; Index: Integer); override;
    procedure ExportObject(Obj: TfrxComponent); override;
    function UseParallelPages: Boolean;
    function CreateMatrix: TfrxIEMatrix;
    procedure ExportPage(Draft: TObject);

  published

    property OpenAfterExport;
    property OverwritePrompt;

    { Normally, each page of a report is saved as a separate excel sheet.
      This property allows to merge all pages and save them as a single
      big excel sheet }

    property SingleSheet: Boolean read FSingleSheet write FSingleSheet default False;

    { Removes empty rows from produced Excel sheets }

    property DeleteEmptyRows: Boolean read FDeleteEmptyRows write FDeleteEmptyRows default False;

    { All row heights will be multiplied by this factor }

    property RowHeightScale: Extended read FRowHeightScale write SetRowHeightScale {default 1};

    { The report can be reorganized in the following way:

        1. All the data is stored to a single continuos page.
        2. This page is splitted into same sized chunks (each chunk has ChunkSize rows)
        3. Each chunk is written to a separate Excel sheet.

      If ChunkSize is zero, this method is not used. If ChunkSize is
      greater than zero, the property SingleSheet must be set to True,
      otherwise an exception will be raised when trying to export a report. }

    property ChunkSize: LongInt read FChunkSize write SetChunkSize;

    { Normally, MS Excel draws lines around each cell. This feature
      can be disabled by this property }

    property GridLines: Boolean read FGridLines write FGridLines default True;

    { This property controls TfrxIEMatrix.Inaccuracy field.
      By default, it equals to 0.1. You should not set this
      field to zero, due to this can produce nonpredictable
      results }

    property Inaccuracy: Extended read FInaccuracy write FInaccuracy;

    { Original report is exported to an xls document with an
      inaccuracy. Sometimes this causes that data fitted to
      an original page (A4, A3, etc.) don't fit to the same
      page after exporting. This exporter can shrink the data
      if it doesn't fit to the excel page. }

    property FitPages: Boolean read FFitPages write FFitPages;

    { Specifies whether to export pictures or not }

    property Pictures: Boolean read FPictures write FPictures;

    { The list of properties below specify some attributes of
      the generated xls file. All of these properties may be empty.
      If a property is empty, it will not be written to the
      output file.

      Note, that all of these properties are not Unicode. That's why
      MS Excel 2003 does not support Unicode strings in document
      properties. }

    property Author: AnsiString read FAuthor write FAuthor;
    property Comment: AnsiString read FComment write FComment;
    property Keywords: AnsiString read FKeywords write FKeywords;
    property Revision: AnsiString read FRevision write FRevision;
    property AppName: AnsiString read FAppName write FAppName;
    property Subject: AnsiString read FSubject write FSubject;
    property Category: AnsiString read FCategory write FCategory;
    property Company: AnsiString read FCompany write FCompany;
    property Title: AnsiString read FTitle write FTitle;
    property Manager: AnsiString read FManager write FManager;

    { If a non empty password is set, the generated document
      will be encrypted with the RC4 cipher. The maximum
      password length is 255 unicode characters. }

    property Password: WideString read FPassword write SetPassword;

    { • Description

      A big report can contain many pages that can be exported separately by
      different parallel threads. A set of report pages can be passed to a few
      threads, afterwards each thread will export a given number of report pages.
      After that all pages will be combined to a single Excel document.

      • Notices

      This property specifies a count of these threads. Probably, the best value
      of this property is the count of processors on the current machine.
      This property is not actual when the machine is exporting several
      reports in parallel and furthermore creating additional threads in this
      case may lead to a failure, because each thread requires system resources.

      • Implementation notes

      The export filter begins from a report that contains a set of GUI elements placed
      on a few report pages. The main thread runs over all report pages and for each page
      selects a set of GUI elements that can appear in the resulting document. All
      elements from a report page are put into TfrxIEMatrix object and pushed to a list
      of such matrix objects. A set of threads are waiting for a moment when the list
      of matrix objects will become nonempty. When such an event occurs, some thread
      selects a matrix object and begin creating an Excel sheet. When a thread has
      generated an Excel sheet, it adds this sheet to a list of sheets. When the main
      thread has converted all report pages to matrix object it becomes waiting for
      threads that are generating Excel sheets. When all sheets are generated, the main
      thread gets all sheets from the list of sheets and combines them to a single
      Excel document. Afterwards it optionally performs encrypting and writes the document
      to a specified data stream or a disk file. }

    property ParallelPages: LongInt read FParallelPages write SetParallelPages; {default 0}

    { A memo component can contain a text beginning with the "=" sign. In this case
      the rest of the text is assumed to be an Excel formula and the memo is exported as
      a formula. Example of such a memo:

        = SUM(A1:B2) + 5
        =AG18*12

      If the text appears to be an invalid formula (there're either syntax or semantic issues),
      then the memo is exported as a normal text cell.

      If ExportFormulas = True, then all texts beginning with "=" are assumed to be formulas.
      If ExportFormulas = False, then the leading "=" has no special meaning for the export. }

    property ExportFormulas: Boolean read FExportFormulas write FExportFormulas default True;

  end;

implementation

uses
  frxUtils,
  frxRes,
  Math,
  frxCBFF, frxExportBIFFDialog;

{ TfrxIEMatrix.Inaccuracy values }

const
  GoodQuality: Extended = 2.0;
  DraftQuality: Extended = 10.0;

{ TfrxBIFFExport }

constructor TfrxBIFFExport.Create(AOwner: TComponent);
begin
  inherited;

  //FParallelPages := 3;

  FGridLines      := True;
  FPictures       := True;
  FSingleSheet    := False;
  FFitPages       := False;
  FInaccuracy     := DraftQuality;
  FAccess         := OlepsAfAll;
  FRowHeightScale := 1.0;
  FDeleteEmptyRows:= False;
  FExportFormulas := True;

  DefaultExt      := '.xls';
  FilterDesc := frxGet(8009);
end;

procedure TfrxBIFFExport.SetChunkSize(Value: LongInt);
begin
  if Value < 0 then
    raise Exception.Create(frxGet(9160));

  FChunkSize := Value;
end;

procedure TfrxBIFFExport.SetPassword(const s: WideString);
begin
  if Length(s) > 255 then
    raise Exception.CreateFmt(frxGet(9180), [Length(s), 255]);

  FPassword := s;
end;

procedure TfrxBIFFExport.SetRowHeightScale(Value: Extended);
begin
  if Value > 0 then
    FRowHeightScale := Value
  else
    raise Exception.Create('RowHeightScale must be positive')
end;

procedure TfrxBIFFExport.SetParallelPages(Count: LongInt);
begin
  if (Count < 0) or (Count > 64) then
    raise Exception.CreateFmt('Invalid value of ParallelPages property: %d', [Count]);

  FParallelPages := Count;
end;

function TfrxBIFFExport.UseParallelPages: Boolean;
begin
  Result := (ParallelPages > 0) and not FSingleSheet;
end;

class function TfrxBIFFExport.GetDescription: string;
begin
  Result := frxGet(9151);
end;

function TfrxBIFFExport.GetExportOptionsDraft: TfrxBiffPageOptions;
begin
  ZeroMemory(@Result, SizeOf(Result));

  Result.Matrix     := FMatrix;
  Result.Pictures   := FPictures;
  Result.PageBreaks := FSingleSheet;
  Result.WorkBook   := FWB;
  Result.Page       := FLastPage;
  Result.TSW        := FTSW;
  Result.ZCW        := FZCW;
  Result.FitPages   := FFitPages;
  Result.GridLines  := FGridLines;
  Result.RHScale    := RowHeightScale;
  Result.Formulas   := ExportFormulas;
end;

function TfrxBIFFExport.CreateMatrix: TfrxIEMatrix;
var
  m: TfrxIEMatrix;
begin
  m := TfrxIEMatrix.Create(UseFileCache, Report.EngineOptions.TempDir);

  with m do
  begin
    Background      := False;
    BackgroundImage := False;
    Printable       := ExportNotPrintable;
    RichText        := False;
    PlainRich       := False;
    Inaccuracy      := FInaccuracy;
    DeleteHTMLTags  := False;
    Images          := True;
    WrapText        := False;
    EmptyLines      := not DeleteEmptyRows;
    BrushAsBitmap   := False;
    EMFPictures     := True;
    MaxCellWidth    := 2000.0; // Actually, MS Excel allows 2303.96 pixels
    MaxCellHeight   := Floor(8192 / 20 / 72 * 96) / RowHeightScale; // 8192 twips expressed in pixels
  end;

  m.DotMatrix := Report.DotMatrixReport;
  m.ShowProgress := ShowProgress;

  Result := m;
end;

procedure TfrxBIFFExport.ExportPage(Draft: TObject);
var
  s: TfrxDraftSheet;
begin
  s := TfrxDraftSheet(Draft);
  s.Options.Matrix.Prepare;

  try
    s.Options.Sheet := frxConvertMatrixToBiffSheet(s.Options, False);
  except
    s.Options.Sheet := nil;
  end;

  s.Options.Matrix.Free;
  s.Options.Matrix := nil;
end;

function TfrxBIFFExport.Start: Boolean;
begin
  Result := False; // Default

  { Splitting to chunks assumes that chunks
    are saved to different sheets. }

  if (FChunkSize > 0) and FSingleSheet then
    raise Exception.Create(frxGet(9161));

  if (FileName = '') and not Assigned(Stream) then
    Exit;

  SuppressPageHeadersFooters := FSingleSheet or (FChunkSize > 0);

  FWB := TBiffWorkbook.Create;
  FZCW := FWB.Font[0].StrWidth('0');
  FTSW := FWB.Font[0].StrWidth('   ');

  if UseParallelPages then
    FDraftPool := TDpDraftPool.Create(ParallelPages,
      Report.PreviewPages.Count, ExportPage);

  Result := True;
  FMatrix := nil;
end;

procedure TfrxBIFFExport.StartPage(Page: TfrxReportPage; Index: Integer);
begin
  if FMatrix = nil then
    FMatrix := CreateMatrix;
end;

class function TfrxBIFFExport.ExportDialogClass: TfrxBaseExportDialogClass;
begin
  Result := TfrxBIFFExportDialog;
end;

procedure TfrxBIFFExport.ExportObject(Obj: TfrxComponent);
var
  v: TfrxView;
begin
  inherited;
  if Obj.Page <> nil then
    Obj.Page.Top := FMatrix.Inaccuracy;

  if Obj.Name = '_pagebackground' then
    Exit;

  if Obj is TfrxView then
  begin
    v := Obj as TfrxView;

    if vsExport in v.Visibility then
      FMatrix.AddObject(v);
  end;
end;

procedure TfrxBIFFExport.FinishPage(Page: TfrxReportPage; Index: Integer);
var
  po: TfrxBiffPageOptions;
  ds: TfrxDraftSheet;
begin
  with FLastPage do
  begin
    PaperWidth    := Page.PaperWidth;
    PaperHeight   := Page.PaperHeight;
    LeftMargin    := Page.LeftMargin;
    RightMargin   := Page.RightMargin;
    TopMargin     := Page.TopMargin;
    BottomMargin  := Page.BottomMargin;
    Orientation   := TfrxPrintOrient(Page.Orientation);
    PaperSize     := Page.PaperSize;
    PageCount     := Page.PageCount;
    //Name        := Page.Name;
  end;

  if not UseParallelPages then
    with Page do
      FMatrix.AddPage(Orientation, Width, Height, LeftMargin,
        TopMargin, RightMargin, BottomMargin, MirrorMargins, Index);

  if (FChunkSize = 0) and not FSingleSheet then
  begin
    po := GetExportOptionsDraft;
    po.PageId := Index;

    if UseParallelPages then
    begin
      ds := TfrxDraftSheet.Create;
      ds.Options := po;
      FDraftPool.AddDraft(ds);
    end
    else
    begin
      FMatrix.Prepare;
      FWB.AddSheet(frxConvertMatrixToBiffSheet(po, False));
      FMatrix.Free;
    end;

    FMatrix := nil;
  end;
end;

procedure TfrxBIFFExport.Finish;
var
  cd: TCbffDocument;
  po: TfrxBiffPageOptions;
  img: TList;
  i: LongInt;
  fs: TStream;
begin

  { Combine all Excel sheets created by a few
    threads into a single workbook }

  if UseParallelPages then
  begin
    FDraftPool.WaitForThreads;

    for i := 0 to FDraftPool.Sheets.Count - 1 do
      with TfrxDraftSheet(FDraftPool.Sheets[i]) do
        if Options.Sheet <> nil then
          FWB.AddSheet(Options.Sheet);

    FDraftPool.Free;
  end;

  { Write the entire report to a single excel sheet }

  if SingleSheet and (FMatrix <> nil) then
  begin
    FMatrix.Prepare;
    po := GetExportOptionsDraft;
    po.PageId := 0;
    FWB.AddSheet(frxConvertMatrixToBiffSheet(po, Showprogress));
    FMatrix.Clear;
  end;

  { Split the entire report into chunks }

  if (FChunkSize > 0) and not FSingleSheet and (FMatrix <> nil) then
  begin
    if FChunkSize > frxBiff.BiffMaxRow then FChunkSize := frxBiff.BiffMaxRow;
    FMatrix.Prepare;
    img := TList.Create;

    if FPictures then
      for i := 0 to FMatrix.GetObjectsCount - 1 do
        with FMatrix.GetObjectById(i) do
          if (Metafile <> nil) and (Metafile.Width <> 0) then
            img.Add(Pointer(i));

    po := GetExportOptionsDraft;
    po.PageId := 0;
    po.Size.Y := FChunkSize;
    po.Images := img;

    while po.Source.Y < FMatrix.Height do
    begin
      FWB.AddSheet(frxConvertMatrixToBiffSheet(po, ShowProgress, FMatrix.Height));
      Inc(po.Source.Y, FChunkSize);
      Inc(po.PageId);
    end;

    img.Free;
    FMatrix.Clear;
  end;

  if not UseParallelPages then
  begin
    FMatrix.Free;
    FMatrix := nil;
  end;

  { The generated xls file is saved
    as a compound document }

  cd := TCbffDocument.Create;
  InitProgressBar(2, frxGet(9406));

  try

    { Save the workbook to the required CBFF stream }

    SaveWorkbook(cd.Root.Add('Workbook').Stream);
    StepProgressBar;

    { Save the information about the document
      to the required CBFF streams.

      All unicode strings will be saved as ansi-strings,
      because MS Excel 2003 never uses unicode characters in
      the document information. Although OpenOffice allows
      to save unicode to the information, it does it
      in another way as the documentation [MS-OLEPS]
      specifies and MS Excel cannot read such information. }

    SaveSI(cd.Root.Add(#5'SummaryInformation').Stream);
    SaveDSI(cd.Root.Add(#5'DocumentSummaryInformation').Stream);

    { Serialize the CBFF document to a plain stream }

    if Assigned(Stream) then
      cd.Flush(Stream)
    else
    begin
      fs := IOTransport.GetStream(FileName);

      try
        cd.Flush(fs);
      finally
        IOTransport.DoFilterSave(fs);
        IOTransport.FreeStream(fs);
      end;
    end;

    StepProgressBar;
  finally
    cd.Free;
    FWB.Free;
    FreeProgressBar;
  end;
end;

procedure TfrxBIFFExport.SaveWorkbook(s: TStream);
var
  bs: TBiffStream;
begin
  if FPassword <> '' then
    FWB.SetPassword(FPassword);

  bs := TBiffStream.Create(UseFileCache);

  try
    FWB.Flush(bs);
    bs.SaveToStream(s);
  finally
    bs.Free;
  end;
end;

procedure TfrxBIFFExport.SaveSI(s: TStream);
var
  SysTime: SYSTEMTIME;
  Time: FILETIME;
begin
  DateTimeToSystemTime(CreationTime, SysTime);
  SystemTimeToFileTime(SysTime, Time);

  with TOlepsStream.Create do
  try
    with Add(OlepsFmtIdSi) do
    begin
      AddAnsi(OlepsSiTitle,      FTitle);
      AddAnsi(OlepsSiSubject,    FSubject);
      AddAnsi(OlepsSiAuthor,     FAuthor);
      AddAnsi(OlepsSiKeywords,   FKeywords);
      AddAnsi(OlepsSiLastAuthor, FAuthor);
      AddAnsi(OlepsSiRevision,   FRevision);
      AddAnsi(OlepsSiAppName,    FAppName);
      AddAnsi(OlepsSiComment,    FComment);
      {IfDef EXPORT_TEST}
      Time.dwLowDateTime := 543882400;
      Time.dwHighDateTime:= 30714350;
      {EndIf}
      AddTime(OlepsSiCreation, Time);
      AddTime(OlepsSiLastSave, Time);

      Add(OlepsSiAccess, OlepsPtInt).Write(FAccess, 4);
    end;
  finally
    Flush(s);
    Free;
  end;
end;

procedure TfrxBIFFExport.SaveDSI(s: TStream);
begin
  with TOlepsStream.Create do
  try
    with Add(OlepsFmtIdDsi) do
    begin
      AddAnsi(OlepsDsiCategory, FCategory);
      AddAnsi(OlepsDsiCompany,  FCompany);
      AddAnsi(OlepsDsiManager,  FManager);
    end;
  finally
    Flush(s);
    Free;
  end;
end;

procedure TfrxBIFFExport.InitProgressBar(Steps: Integer; Text: string);
begin
  if ShowProgress then
  begin
    FProgress := TfrxProgress.Create(nil);
    FProgress.Execute(Steps, Text, False, True);
  end;
end;

procedure TfrxBIFFExport.StepProgressBar;
begin
  if ShowProgress then
    FProgress.Tick
end;

procedure TfrxBIFFExport.FreeProgressBar;
begin
  FProgress.Free
end;

end.

