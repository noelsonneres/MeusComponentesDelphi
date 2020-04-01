
{******************************************}
{                                          }
{             FastReport v6.0              }
{               XLSX export                }
{                                          }
{         Copyright (c) 1998-2017          }
{             Fast Reports Inc.            }
{                                          }
{******************************************}

unit frxExportXLSX;

interface

{$I frx.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Types,
  frxClass, frxExportMatrix, ShellAPI, frxZip,
  frxOfficeOpen, frxImageConverter, frxExportBaseDialog
{$IFDEF DELPHI16}
, System.UITypes
{$ENDIF}
;

type
{$IFDEF DELPHI16}
[ComponentPlatformsAttribute(pidWin32 or pidWin64)]
{$ENDIF}
  TfrxXLSXExport = class(TfrxBaseDialogExportFilter)
  private
    FExportPageBreaks: Boolean;
    FEmptyLines: Boolean;
    FMatrix: TfrxIEMatrix;
    FDocFolder: string;
    FContentTypes: TStream; // [Content_Types].xml
    FRels: TStream; // _rels/.rels
    FStyles: TStream; // xl/styles.xml
    FWorkbook: TStream; // xl/workbook.xml
    FSharedStrings: TStream; // sharedStrings.xml
    FWorkbookRels: TStream; // xl/_rels/workbook.xml.rels
    FFonts: TStrings; // <fonts> section in xl/styles.xml
    FFills: TStrings; // <fills> section in xl/styles.xml
    FBorders: TStrings; // <borders> section in xl/styles.xml
    FCellStyleXfs: TStrings; // <cellStyleXfs> section in xl/styles.xml
    FCellXfs: TStrings; // <cellXfs> section in xl/styles.xml
    FColors: TList; // <colors> section in xl/styles.xml
    FNumFmts: TStrings; // <numFmts> section in xl/styles.xml
    FPreviousNumFmtsCount: Integer;
    FStrings: TStrings; // <sst> section in xl/sharedStrings
    FStringsCount: Integer; // count of strings in the workbook
    FSingleSheet: Boolean;
    FChunkSize: Integer;
    FLastPage: TfrxMap;
    FWysiwyg: Boolean;
    FPictureType: TfrxPictureType;
    function AddString(s: string): Integer;
    function AddColor(c: TColor): Integer;
    procedure AddColors(const c: array of TColor);
    procedure AddSheet(m: TfrxMap);
    procedure ExportFormats(FNumFmts: TStrings);
    procedure UpdateStyles;
  public
    constructor Create(Owner: TComponent); override;
    class function GetDescription: string; override;
    class function ExportDialogClass: TfrxBaseExportDialogClass; override;
    function Start: Boolean; override;
    procedure Finish; override;
    procedure FinishPage(Page: TfrxReportPage; Index: Integer); override;
    procedure ExportObject(Obj: TfrxComponent); override;
  published
    property ChunkSize: Integer read FChunkSize write FChunkSize;
    property EmptyLines: Boolean read FEmptyLines write FEmptyLines default True;
    property ExportPageBreaks: Boolean read FExportPageBreaks write FExportPageBreaks default True;
    property OpenAfterExport;
    property OverwritePrompt;
    property PictureType: TfrxPictureType read FPictureType write FPictureType;
    property SingleSheet: Boolean read FSingleSheet write FSingleSheet default True;
    property Wysiwyg: Boolean read FWysiwyg write FWysiwyg default True;
  end;

implementation

uses
  frxUtils, frxFileUtils, frxUnicodeUtils, frxRes, frxrcExports, frxGraphicUtils, frxExportXLSXDialog;

const
  StylesRid = 'rId1000_'; // xl/styles.xml
  ThemeRid = 'rId2000_'; // xl/theme1.xml
  SharedStringsRid = 'rId3000_'; // xl/sharedStrings.xml
  WorkbookRid = 'rId4000_'; // xl/workbook.xml
  CoreRid = 'rId5000_'; // docProps/core.xml
  ColWidthFactor = 0.111317;
  RowHeightFactor = 0.754967;
  MarginFactor = 1 / 25.4;

var
  SetFormat : TFormatSettings;

{ TfrxXLSXExport }

class function TfrxXLSXExport.GetDescription: string;
begin
  Result := frxGet(9200);
end;

function TfrxXLSXExport.AddString(s: string): Integer;
var i: integer;
    s1: string;
begin
    s1 := '';
    for i := 1 to length(s) do
    {$IFDEF Delphi12}
      if not CharInSet(s[i], [#0..#9, #11, #12, #14..#31]) then
    {$ELSE}
      if not (s[i] in [#0..#9, #11, #12, #14..#31]) then
    {$ENDIF}
        s1 := s1 + s[i];
    Result := FStrings.Add(Escape(s1));
end;

constructor TfrxXLSXExport.Create(Owner: TComponent);
begin
  inherited;
  DefaultExt := '.xlsx';
  FilterDesc := GetStr('9204');
  FWysiwyg := True;
  FExportPageBreaks := True;
  FSingleSheet := True;
  FEmptyLines := True;
end;

function TfrxXLSXExport.AddColor(c: TColor): Integer;
var
  i, j, k: Integer;
begin
  c := RGBSwap(c);
  j := -1;
  k := 1000000;
  for i := 0 to FColors.Count - 1 do
    if Distance(Integer(FColors[i]), c) < k then
    begin
      k := Distance(Integer(FColors[i]), c);
      j := i;
    end;

  if (k = 0) or (FColors.Count = 56) then
  begin
    Result := j;
    Exit;
  end;

  Result := FColors.Add(Pointer(c));
end;

procedure TfrxXLSXExport.AddColors(const c: array of TColor);
var
  i: Integer;
begin
  for i := Low(c) to High(c) do
    AddColor(c[i]);
end;


  function ClearFormat(fmt: string): string;
  var i: integer;
  begin
    Result := '';
    for i := 1 to length(fmt) do
      {$IFDEF Delphi12}
      if CharInSet(fmt[i], ['#', '0', ' ', ',', '.', ';']) then
      {$ELSE}
      if fmt[i] in ['#', '0', ' ', ',', '.', ';'] then
      {$ENDIF}
        Result := Result + fmt[i];
  end;

  function ConvertFormat(fmt: TfrxFormat): string;
  var
    err,
    p : integer;
    s: string;
  begin
    result := '';
    s := '';

    case fmt.Kind of
    fkText:

    end;

    if length(fmt.FormatStr)>0 then
    begin
      p := pos('.', fmt.FormatStr);
      if p > 0 then
      begin
        s := Copy(fmt.FormatStr, p+1, length(fmt.FormatStr)-p-1);
        val(s, p ,err);
        SetLength(s, p);
        if p>0 then
        begin
{$IFDEF Delphi12}
          s := StringOfChar(Char('0'), p);
{$ELSE}
          FillChar(s[1], p, '0');
{$ENDIF}
          s := '.' + s;
        end;
      end;

      p := pos('%', fmt.FormatStr);
      if p > 0 then
        begin
          case fmt.FormatStr[length(fmt.FormatStr)] of
            'n': result := '#,##0' + s;
            'f': result := '0' + s;
            'g': result := s; // '#,##; -#,##';
            'm': result := '#,##0.00';
          end;
        end
      else
        begin
          if (pos('E', fmt.FormatStr) <> 0) or (pos('e', fmt.FormatStr) <> 0) then
            result := fmt.FormatStr
          else
            if (pos('#', fmt.FormatStr) <> 0) or (pos('0', fmt.FormatStr) <> 0) then
              result := ClearFormat(fmt.FormatStr)
            else
              result := '#,##0.00';
        end;
    end;
  end;

class function TfrxXLSXExport.ExportDialogClass: TfrxBaseExportDialogClass;
begin
  Result := TfrxXLSXExportDialog;
end;

procedure   TfrxXLSXExport.ExportFormats(FNumFmts: TStrings);
var
  i, res_count:  Integer;
  res:              string;
  EStyle:           TfrxIEMStyle;
  format_base:      TfrxFormat;
  format_string:    string;
begin
  if FNumFmts.Count = 1 then FPreviousNumFmtsCount := 0;
  res_count := 166 + FPreviousNumFmtsCount;
  res := '';
  for i := 0 to FMatrix.StylesCount-1 do
  begin
    EStyle := FMatrix.GetStyleById(i);
    format_base := EStyle.FDisplayFormat;
    if format_base.Kind = fkNumeric then
    begin
      format_string := ConvertFormat(format_base);
      res := Format('<numFmt numFmtId="%d" formatCode="%s" />',
{$IFDEF Delphi12}
        [res_count + i,format_string],SetFormat);
{$ELSE}
        [res_count + i,UTF8Encode(format_string)],SetFormat);
{$ENDIF}
        FNumFmts.Add(res);
    end;
  end;
end;

function TfrxXLSXExport.Start: Boolean;
var
  TempStream: TStream;
begin
  Result := False; // Default

  if (FileName = '') and not Assigned(Stream) then
    Exit;

  FMatrix := TfrxIEMatrix.Create(UseFileCache, Report.EngineOptions.TempDir);

  with FMatrix do
  begin
    Background      := False;
    BackgroundImage := False;
    Printable       := ExportNotPrintable;
    RichText        := False;
    PlainRich       := False;
    DeleteHTMLTags  := True;
    Images          := True;
    WrapText        := False;
    ShowProgress    := False;
    BrushAsBitmap   := False;
    EMFPictures     := True;
    EmptyLines      := Self.EmptyLines;
  end;

  if not Wysiwyg then
    FMatrix.Inaccuracy := 10.0
  else
    FMatrix.Inaccuracy := 2.0;

  FMatrix.DotMatrix := Report.DotMatrixReport;
  SuppressPageHeadersFooters := not EmptyLines;
  Result := True;

  { additional data }

  FFonts := TfrxStrList.Create;
  FFills := TfrxStrList.Create;
  FBorders := TfrxStrList.Create;
  FCellStyleXfs := TfrxStrList.Create;
  FNumFmts := TfrxStrList.Create;
  FStrings := TfrxStrList.Create;
  FStringsCount := 0;
  FCellXfs := TfrxStrList.Create;
  FColors := TList.Create;

  { file structure }

  try
//  FDocFolder := GetTempFile;
//  DeleteFile(FDocFolder);
//  FDocFolder := FDocFolder + '\';
//  MkDir(FDocFolder);
//  MkDir(FDocFolder + 'xl');
//  MkDir(FDocFolder + 'xl/_rels');
//  MkDir(FDocFolder + '_rels');
//  MkDir(FDocFolder + 'xl/worksheets');
//  MkDir(FDocFolder + 'xl/worksheets/_rels');
//  MkDir(FDocFolder + 'xl/drawings');
//  MkDir(FDocFolder + 'xl/drawings/_rels');
//  MkDir(FDocFolder + 'xl/media');
//  MkDir(FDocFolder + 'docProps');

//  FDocFolder := GetTempFile;
//  IOTransport.TempFilter.BasePath := FDocFolder;
//  DeleteFile(FDocFolder);
  FDocFolder := IOTransport.TempFilter.BasePath;
  CreateDirs(IOTransport.TempFilter, [ 'xl', 'docProps', '_rels', 'xl/_rels', 'xl/worksheets', 'xl/worksheets/_rels', 'xl/drawings', 'xl/drawings/_rels', 'xl/media']);
  FDocFolder := FDocFolder + '\';

  { [Content_Types].xml }

  FContentTypes := IOTransport.TempFilter.GetStream(FDocFolder + '[Content_Types].xml');
  //TFileStream.Create(FDocFolder + '[Content_Types].xml', fmCreate);
  with TfrxWriter.Create(FContentTypes) do
  begin
    Write(['<?xml version="1.0" encoding="UTF-8" standalone="yes"?>',
      '<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">',
      '<Default Extension="xml" ContentType="application/xml"/>',
      '<Default Extension="rels" ContentType=',
      '"application/vnd.openxmlformats-package.relationships+xml"/>',
      '<Default Extension="emf" ContentType="image/x-emf"/>',
      '<Override PartName="/xl/styles.xml" ContentType=',
      '"application/vnd.openxmlformats-officedocument.spreadsheetml.styles+xml"/>',
      '<Override PartName="/xl/workbook.xml" ContentType=',
      '"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet.main+xml"/>',
      '<Override PartName="/xl/sharedStrings.xml" ContentType=',
      '"application/vnd.openxmlformats-officedocument.spreadsheetml',
      '.sharedStrings+xml"/>',
      '<Override PartName="/docProps/core.xml" ContentType="application/vnd.',
      'openxmlformats-package.core-properties+xml"/>']);

    Free;
  end;

  { _rels/.rels }

  FRels := IOTransport.TempFilter.GetStream(FDocFolder + '_rels/.rels');
  //TFileStream.Create(FDocFolder + '_rels/.rels', fmCreate);
  with TfrxWriter.Create(FRels) do
  begin
    Write(['<?xml version="1.0" encoding="UTF-8" standalone="yes"?>',
      '<Relationships xmlns="http://schemas.openxmlformats.org/',
      'package/2006/relationships">',
      '<Relationship Id="', WorkbookRid, '" Type="http://schemas.openxmlformats.',
      'org/officeDocument/2006/relationships/officeDocument" Target="xl/workbook.xml"/>',
      '<Relationship Id="', CoreRid, '" Type="http://schemas.openxmlformats.org/package/',
      '2006/relationships/metadata/core-properties" Target="docProps/core.xml"/>',
      '</Relationships>']);

    Free;
  end;

  { docProps/core.xml }
  TempStream := IOTransport.TempFilter.GetStream(FDocFolder + 'docProps/core.xml');
  with TfrxWriter.Create(TempStream) do
  begin
      Write(['<?xml version="1.0" encoding="UTF-8" standalone="yes"?>',
      '<cp:coreProperties xmlns:cp="http://schemas.openxmlformats.org/package/2006/metadata/core-properties"',
      ' xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:dcmitype="http://purl.org/dc/dcmitype/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">',
      '<dc:title>' + Report.ReportOptions.Name + '</dc:title>',
      '<dc:subject></dc:subject>',
      '<dc:creator>' + Report.ReportOptions.Author + '</dc:creator>',
      '<cp:keywords></cp:keywords>',
      '<dc:description>' + Report.ReportOptions.Description.Text + '</dc:description>',
      '<cp:lastModifiedBy>' + Report.ReportOptions.Author + '</cp:lastModifiedBy>',
      '<cp:revision>2</cp:revision>',
      '<dcterms:created xsi:type="dcterms:W3CDTF">' + FormatDateTime('yyyy-mm-dd"T"hh:nn:ss"Z"', DateTimeToUTC(Now)) + '</dcterms:created>',
      '<dcterms:modified xsi:type="dcterms:W3CDTF">' +FormatDateTime('yyyy-mm-dd"T"hh:nn:ss"Z"', DateTimeToUTC(Now)) + '</dcterms:modified>',
      '</cp:coreProperties>'], True);

    Free;
  end;
  IOTransport.TempFilter.FreeStream(TempStream);
  { xl/workbook.xml }

  FWorkbook := IOTransport.TempFilter.GetStream(FDocFolder + 'xl/workbook.xml');
  //TFileStream.Create(FDocFolder + 'xl/workbook.xml', fmCreate);
  with TfrxWriter.Create(FWorkbook) do
  begin
    Write(['<?xml version="1.0" encoding="UTF-8" standalone="yes"?>',
      '<workbook xmlns="http://schemas.openxmlformats.org/',
      'spreadsheetml/2006/main" xmlns:r="http://schemas.openxmlformats.org/',
      'officeDocument/2006/relationships">',
      '<fileVersion appName="xl" lastEdited="4" lowestEdited="4"',
      ' rupBuild="4505"/>',
      '<workbookPr defaultThemeVersion="124226"/>',
      '<bookViews><workbookView xWindow="0" yWindow="0"',
      ' windowWidth="15480" windowHeight="8190" tabRatio="400" firstSheet="0"',
      ' activeTab="0"/></bookViews>',
      '<sheets>']);

    Free;
  end;

  { xl/styles.xml }

  FStyles := IOTransport.TempFilter.GetStream(FDocFolder + 'xl/styles.xml');
  //TFileStream.Create(FDocFolder + 'xl/styles.xml', fmCreate);
  WriteStr(FStyles, '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>');

  { xl/sharedStrings.xml }

  FSharedStrings := IOTransport.TempFilter.GetStream(FDocFolder + 'xl/sharedStrings.xml');
  //TFileStream.Create(FDocFolder + 'xl/sharedStrings.xml', fmCreate);
  WriteStr(FSharedStrings, '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>');

  { xl/_rels/workbook.xml.rels }

  FWorkbookRels := IOTransport.TempFilter.GetStream(FDocFolder + 'xl/_rels/workbook.xml.rels');
  //TFileStream.Create(FDocFolder + 'xl/_rels/workbook.xml.rels', fmCreate);
  with TfrxWriter.Create(FWorkbookRels) do
  begin
    Write(['<?xml version="1.0" encoding="UTF-8" standalone="yes"?>',
      '<Relationships xmlns="http://schemas.openxmlformats.org/',
      'package/2006/relationships">',
      '<Relationship Id="', StylesRid,
      '" Type="http://schemas.openxmlformats.org/officeDocument/2006/',
      'relationships/styles" Target="styles.xml"/>',
      '<Relationship Id="', SharedStringsRid,
      '" Type="http://schemas.openxmlformats.org/officeDocument/2006/',
      'relationships/sharedStrings" Target="sharedStrings.xml"/>']);

    Free;
  end;
  except
      on e: Exception do
        case Report.EngineOptions.NewSilentMode of
          simSilent:        Report.Errors.Add(e.Message);
          simMessageBoxes:  frxErrorMsg(e.Message);
          simReThrow:       raise;
        end;
  end;
end;

procedure TfrxXLSXExport.ExportObject(Obj: TfrxComponent);
var
  v: TfrxView;
begin
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

procedure TfrxXLSXExport.AddSheet(m: TfrxMap);

  function A1(x, y: Integer): string;
  begin
    Result := '';

    if x = 0 then
      Result := 'A'
    else if x < 26 then
      Result := Chr(Ord('A') + x)
    else
      Result := Chr(Ord('A') + x div 26 - 1) + Chr(Ord('A') + x mod 26);

    Result := Result + IntToStr(y + 1);
  end;

  function ColWidth(i: Integer): Double;
  begin
    with FMatrix do
      Result := ColWidthFactor * (GetXPosById(i + 1) - GetXPosById(i));
  end;

  function RowHeight(i: Integer): Double;
  begin
    with FMatrix do
      Result := RowHeightFactor * (GetYPosById(i + 1) - GetYPosById(i));
  end;

  function ColorText(col: TColor) : String;
  var
    R0,R1,G0,G1,B0,B1: Byte;
  begin
    R1 := GetRValue(col) and $f;
    R0 := (GetRValue(col) shr 4) and $f;
    G1 := GetGValue(col) and $f;;
    G0 := (GetGValue(col) shr 4) and $f;
    B1 := GetBValue(col) and $f;;
    B0 := (GetBValue(col) shr 4) and $f;
    Result := Format('FF%x%x%x%x%x%x', [R0,R1,G0,G1,B0,B1] );
  end;

  function Border(Side: string; line: TfrxFrameLine; Exists: Boolean): string;
  var
    BorderType: String;
  begin
    if not Exists then
      Result := Format('<%s/>', [Side])
    else begin
      case line.Style of
      fsSolid:        if Line.Width < 1.5 then BorderType := 'thin'
                      else
                      if Line.Width < 2.5 then BorderType := 'medium'
                      else
                      BorderType := 'thick';
      fsDash:         BorderType := 'dashed';
      fsDot:          BorderType := 'dotted';
      fsDashDot:      BorderType := 'dashDot';
      fsDashDotDot:   BorderType := 'dashDotDot';
      fsDouble:       BorderType := 'double';
      fsAltDot:       BorderType := 'dashDot';
      fsSquare:       BorderType := 'thin';
      else            BorderType := 'thin';
      end;
      Result := Format('<%s style="%s"><color rgb="%s"/></%s>',
        [Side, BorderType, ColorText(line.Color), Side], SetFormat);
    end;
  end;

  function XLHAlign(a: TfrxHAlign): string;
  begin
    case a of
      haLeft: Result := 'left';
      haRight: Result := 'right';
      haCenter: Result := 'center';
      else Result := 'left';
    end;
  end;

  function XLVAlign(a: TfrxVAlign): string;
  begin
    case a of
      vaTop: Result := 'top';
      vaBottom: Result := 'bottom';
      vaCenter: Result := 'center';
      else Result := 'top';
    end;
  end;

  function XLHAlign90(a: TfrxHAlign; Rotation: integer): string;
  begin
    if Rotation = 90 then
      begin
        case a of
          haLeft: Result := 'bottom';
          haRight: Result := 'top';
          haCenter: Result := 'center';
          else Result := 'bottom';
        end;
      end
    else
      begin
        case a of
          haLeft: Result := 'top';
          haRight: Result := 'bottom';
          haCenter: Result := 'center';
          else Result := 'top';
        end;
      end;
  end;

  function XLVAlign90(a: TfrxVAlign; Rotation: integer): string;
  begin
    if Rotation = 90 then
      begin
        case a of
          vaTop: Result := 'left';
          vaBottom: Result := 'right';
          vaCenter: Result := 'center';
          else Result := 'left';
        end
      end
    else
      begin
        case a of
          vaTop: Result := 'right';
          vaBottom: Result := 'left';
          vaCenter: Result := 'center';
          else Result := 'right';
        end
      end;
  end;


  function Pattern(s: TBrushStyle): string;
  begin
    case s of
      bsSolid: Result := 'solid';
      bsClear: Result := 'solid';
      else Result := 'none';
    end;
  end;

  function BoolToInt(b: Boolean): Integer;
  begin
    if b then
      Result := 1
    else
      Result := 0;
  end;

  function FS(const s: string; b: Boolean): string;
  begin
    if b then
      Result := s
    else
      Result := '';
  end;

  function Orientation(x: Integer): string;
  begin
    if x = 0 then
      Result := 'portrait'
    else
      Result := 'landscape';
  end;

  function GetCol(x: Double): Integer;
  var
    c: Integer;
  begin
    for c := 0 to FMatrix.Width - 1 do
      if FMatrix.GetXPosById(c) > x - 1e-6 then
        Break;

    Result := c;
  end;

  function GetRow(y: Double): Integer;
  var
    r: Integer;
  begin
    for r := 0 to FMatrix.Height - 1 do
      if FMatrix.GetYPosById(r) > y - 1e-6 then
        Break;

    Result := r;
  end;

  function GetFormatCode(f: TfrxFormat; idx: Integer) : Integer;
  var
    res_count: Integer;
  begin
    Result := 0;
    res_count := 166;

    case f.Kind of
      fkText:     Result:= 49;
      fkNumeric:  begin
        Result := idx + res_count;
      end;
    end;
  end;

  function GetSystemDecimalSeparator: Char;
  begin
    {$IFDEF Delphi15}
    Result := FormatSettings.DecimalSeparator
    {$ELSE}
    Result := SysUtils.DecimalSeparator
    {$ENDIF}
  end;

  function GetSystemThousandSeparator: Char;
  begin
    {$IFDEF Delphi15}
    Result := FormatSettings.ThousandSeparator
    {$ELSE}
    Result := SysUtils.ThousandSeparator
    {$ENDIF}
  end;

  function StrIsFloat(const AText: string; ObjDS, ObjTS: Char): boolean;
  var l,i: integer;
  begin
    l := Length(AText);
    Result := (l = 0);
    for i := 1 to l do
    begin
      {$IFDEF Delphi12}
      Result := CharInSet(AText[i], ['0', '1'..'9', WideChar(GetSystemDecimalSeparator),
                WideChar(GetSystemThousandSeparator), 'E', 'e', '-', '+', WideChar(ObjDS), WideChar(ObjTS)]);
      {$ELSE}
      Result := Char(AText[i]) in ['0','1'..'9', GetSystemDecimalSeparator, GetSystemThousandSeparator, 'E', 'e', '-', '+', ObjDS, ObjTS];
      {$ENDIF}
      if not Result then
        Exit;
    end;
  end;

var
  f, i, j, k, l, x, y, dx, dy: Integer;
  Obj: TfrxIEMObject;
  r: TfrxRect;
  MCells: array of TRect; // merged cells
  StrList: TStrings;
  StylesMap: array of Integer;
  Pictures: TList; // of TfrxIEMObject
  s: string;
  ss: TStream; // xl/worksheets/sheetXXX.xml
  style: TfrxIEMStyle;
  rotor, td: string;
  TempStream: TStream;
  TempThousandSeparator, TempDecimalSeparator: Char;
begin
  try
    WriteStr(FContentTypes, '<Override PartName="/xl/worksheets/sheet' + IntToStr(m.Index) +
      '.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml' +
      '.worksheet+xml"/>');

  WriteStr(FWorkbook, Format('<sheet name="%s %d" sheetId="%d" r:id="rId%d"/>',
    [frxGet(9154), m.Index, m.Index, m.Index], SetFormat),{$IFDEF Delphi12}True{$ELSE}False{$ENDIF});

  WriteStr(FWorkbookRels, Format('<Relationship Id="rId%d" Type="http://schemas.' +
    'openxmlformats.org/officeDocument/2006/relationships/worksheet" ' +
    'Target="worksheets/sheet%d.xml"/>', [m.Index, m.Index], SetFormat));

  ss := IOTransport.TempFilter.GetStream(FDocFolder + 'xl/worksheets/sheet' + IntToStr(m.Index) +
    '.xml');
//  TFileStream.Create(FDocFolder + 'xl/worksheets/sheet' + IntToStr(m.Index) +
//    '.xml', fmCreate);

    with TfrxWriter.Create(ss) do
    begin
      if FMatrix.GetObjectsCount > 0 then
        Write(['<?xml version="1.0" encoding="UTF-8" standalone="yes"?>',
          '<worksheet xmlns="http://schemas.openxmlformats.org/',
          'spreadsheetml/2006/main" xmlns:r="http://schemas.openxmlformats.org/',
          'officeDocument/2006/relationships">',
          Format('<dimension ref="%s:%s"/>',
            [A1(0, 0), A1(FMatrix.Width - 1, m.LastRow - m.FirstRow)]),
          '<sheetViews><sheetView showGridLines="1"',
          ' workbookViewId="0"/></sheetViews>'])
      else
        Write(['<?xml version="1.0" encoding="UTF-8" standalone="yes"?>',
          '<worksheet xmlns="http://schemas.openxmlformats.org/',
          'spreadsheetml/2006/main" xmlns:r="http://schemas.openxmlformats.org/',
          'officeDocument/2006/relationships">',
          Format('<dimension ref="%s:%s"/>',
            [A1(0, 0), A1(0, 0)]),
          '<sheetViews><sheetView showGridLines="1"',
          ' workbookViewId="0"/></sheetViews>']);
      Free;
    end;

  { columns widths }

    if FMatrix.GetObjectsCount > 0 then
      begin
        WriteStr(ss, '<cols>');

        for i := 0 to FMatrix.Width - 2 do
          WriteStr(ss, Format('<col min="%d" max="%d" width="%f" customWidth="1"/>',
            [i + 1, i + 1, ColWidth(i)], SetFormat));

        WriteStr(ss, '</cols>');
      end;

  { merged cells }

  SetLength(MCells, FMatrix.GetObjectsCount);

    if Length(MCells) > 0 then
      for i := 0 to High(MCells) do
        with MCells[i] do
        begin
          Left := 1000000;
          Top := 1000000;
          Right := -1;
          Bottom := -1;
        end;

  { cell styles }

    SetLength(StylesMap, FMatrix.GetStylesCount);

    { First default border }
    if Length(StylesMap) > 0 then
      style := FMatrix.GetStyleById(0)
    else
      style := TfrxIEMStyle.Create;
    FBorders.Add('<border>' +
    Border('left', style.LeftLine, False) +
    Border('right', style.RightLine, False) +
    Border('top', style.TopLine, False) +
    Border('bottom', style.BottomLine, False) +
    '</border>');

    with FMatrix do
      for i := 0 to GetStylesCount - 1 do
        with GetStyleById(i) do
        begin
          f := GetFormatCode( FDisplayFormat, i + FPreviousNumFmtsCount );
          j := FFonts.Add(Format('<font>' + FS('<b/>', fsBold in Font.Style) +
            FS('<i/>', fsItalic in Font.Style) + FS('<u/>', fsUnderline in Font.Style) +
            FS('<strike/>', fsStrikeOut in Font.Style) +
            '<sz val="%d"/><color rgb="%s"/>',
            [Font.Size, ColorText(Font.Color)], SetFormat)+
            '<name val="' + Font.Name + '"/>' +  Format('<charset val="%d"/></font>', [Font.Charset], SetFormat));

            style := FMatrix.GetStyleById(i);

          k := FBorders.Add('<border>' +
            Border('left', style.LeftLine, ftLeft in FrameTyp) +
            Border('right', style.RightLine, ftRight in FrameTyp) +
            Border('top', style.TopLine, ftTop in FrameTyp) +
            Border('bottom', style.BottomLine, ftBottom in FrameTyp) +
            '</border>');

          if Color <> 0 then
            l := FFills.Add(Format('<fill><patternFill patternType="%s">' +
                 '<fgColor indexed="%d"/></patternFill></fill>', [Pattern(BrushStyle),
                 AddColor(Color)]))
          else
            l := FFills.Add('<fill><patternFill patternType="none">/></patternFill></fill>');
          
          rotor := '';
          if Rotation <> 0 then begin
            if Rotation <= 90 then
              rotor := IntToStr( Rotation)
            else if Rotation >= 270 then
              rotor := IntToStr( Rotation - 90 )
            else
              rotor := '0';  // Limit  of angle between +90 and -90 degrees

            rotor := ' textRotation="' + rotor + '" ';
          end;

          if (Rotation = 90) or (Rotation = 270) then
            StylesMap[i] := FCellXfs.Add(Format('<xf numFmtId="%d" fontId="%d" fillId="%d"' +
              ' borderId="%d" xfId="0" applyNumberFormat="0" applyFont="1" applyFill="1"' +
              ' applyBorder="1" applyAlignment="1" applyProtection="1">' +
              '<alignment horizontal="%s" vertical="%s" wrapText="%d"' +  rotor +
              ' readingOrder="1"/></xf>', [f, j, l, k, XLVAlign90(VAlign, Rotation),
              XLHAlign90(HAlign, Rotation), BoolToInt(WordWrap)], SetFormat))
          else
            StylesMap[i] := FCellXfs.Add(Format('<xf numFmtId="%d" fontId="%d" fillId="%d"' +
              ' borderId="%d" xfId="0" applyNumberFormat="0" applyFont="1" applyFill="1"' +
              ' applyBorder="1" applyAlignment="1" applyProtection="1">' +
              '<alignment horizontal="%s" vertical="%s" wrapText="%d"' +  rotor +
              ' readingOrder="1"/></xf>', [f, j, l, k, XLHAlign(HAlign),
              XLVAlign(VAlign), BoolToInt(WordWrap)], SetFormat))
        end;
    FPreviousNumFmtsCount := FPreviousNumFmtsCount + FMatrix.StylesCount;
    { cells }

      WriteStr(ss, '<sheetData>');
      if FMatrix.GetObjectsCount > 0 then
        begin
          for i := m.FirstRow to m.LastRow do
          begin
            WriteStr(ss, Format('<row r="%d" ht="%f" customHeight="1">',
              [i - m.FirstRow + 1, RowHeight(i)], SetFormat));

            for j := 0 to FMatrix.Width - 2 do
            begin
              Obj := FMatrix.GetObject(j, i);
              if Obj = nil then Continue;

              with MCells[FMatrix.GetCell(j, i)] do
              begin
                k := i - m.FirstRow;
                if j < Left then Left := j;
                if j > Right then Right := j;
                if k < Top then Top := k;
                if k > Bottom then Bottom := k;
              end;

              td := Trim(Obj.Memo.Text);
              TempThousandSeparator := #0;
              TempDecimalSeparator := #0;
              if (Obj.Style.DisplayFormat.Kind = fkNumeric) and (Obj.Counter = 0) then
                begin
                  if Obj.Style.DisplayFormat.ThousandSeparator <> '' then
                    TempThousandSeparator := Obj.Style.DisplayFormat.ThousandSeparator[1]
                  else
                    TempThousandSeparator := GetSystemThousandSeparator;
                  if Obj.Style.DisplayFormat.DecimalSeparator <> '' then
                    TempDecimalSeparator := Obj.Style.DisplayFormat.DecimalSeparator[1]
                  else
                    TempDecimalSeparator := GetSystemDecimalSeparator;
                end;
              if (Obj.Style.DisplayFormat.Kind = fkNumeric) and (Obj.Counter = 0) and StrIsFloat(td, TempDecimalSeparator, TempThousandSeparator) then
                begin
                  WriteStr(ss, Format('<c r="%s" s="%d">',
                    [A1(j, i - m.FirstRow), StylesMap[Obj.StyleIndex]], SetFormat));
                    td := StringReplace(td, String(TempThousandSeparator), '', [rfReplaceAll]);
                    td := StringReplace(td, String(TempDecimalSeparator), '.', []);
                  WriteStr(ss, Format('<v>%s</v>', [td], SetFormat));
                  Obj.Counter := Obj.Counter+1;
                end
              else
                begin
                  k := AddString(String(Utf8Encode(Obj.Memo.Text)));
                  WriteStr(ss, Format('<c r="%s" s="%d" t="s">',
                    [A1(j, i - m.FirstRow), StylesMap[Obj.StyleIndex]], SetFormat));
                  WriteStr(ss, Format('<v>%d</v>', [k], SetFormat));
                end;

              WriteStr(ss, '</c>');
            end;

            WriteStr(ss, '</row>');
          end;
        end;

    WriteStr(ss, '</sheetData>');

    { merged cells }

    StrList := TStringList.Create;

    for i := 0 to High(MCells) do
      with MCells[i] do
      if (Left <= Right) and (Top <= Bottom) and
        ((Right - Left + 1) * (Bottom - Top + 1) > 1) then
        StrList.Add(Format('<mergeCell ref="%s:%s"/>', [A1(Left, Top), A1(Right, Bottom)], SetFormat));

    if StrList.Count > 0 then
    begin
      WriteStr(ss, Format('<mergeCells count="%d">', [StrList.Count], SetFormat));
      StrList.SaveToStream(ss);
      WriteStr(ss, '</mergeCells>');
    end;

    StrList.Free;

    { pictures }

    Pictures := TList.Create;

    for i := 0 to FMatrix.GetObjectsCount - 1 do
    begin
      FMatrix.GetObjectPos(i, x, y, dx, dy);

      with FMatrix.GetObjectById(i) do
        if (Metafile <> nil) and (Metafile.Width > 0) and (Metafile.Height > 0) and
          (y >= m.FirstRow) and (y + dy - 1 <= m.LastRow) then
          Pictures.Add(FMatrix.GetObjectById(i));
    end;

    if Pictures.Count = 0 then
    begin
      Pictures.Free;
      Pictures := nil;
    end
    else
    begin
      WriteStr(FContentTypes, Format('<Override PartName="/xl/drawings/drawing%d.xml"' +
        ' ContentType="application/vnd.openxmlformats-officedocument.drawing+xml"/>',
        [m.Index], SetFormat));

    { xl/worksheets/_rels/sheetXXX.xml.rels }
    TempStream := IOTransport.TempFilter.GetStream(Format('%sxl/worksheets/_rels/sheet%d.xml.rels',
      [FDocFolder, m.Index], SetFormat));
    with TfrxWriter.Create(TempStream) do
    begin
      Write(['<?xml version="1.0" encoding="UTF-8" standalone="yes"?>',
        '<Relationships xmlns="http://schemas.openxmlformats.org/',
        'package/2006/relationships">',
        Format('<Relationship Id="rId1" Type="http://schemas.' +
          'openxmlformats.org/officeDocument/2006/relationships/drawing"' +
          ' Target="../drawings/drawing%d.xml"/>', [m.Index], SetFormat),
        '</Relationships>']);

      Free;
    end;
    IOTransport.TempFilter.FreeStream(TempStream);
    { xl/drawings/_rels/drawingXXX.xml.rels }
    TempStream := IOTransport.TempFilter.GetStream(Format('%sxl/drawings/_rels/drawing%d.xml.rels',
      [FDocFolder, m.Index], SetFormat));
    with TfrxWriter.Create(TempStream) do
    begin
      Write(['<?xml version="1.0" encoding="UTF-8" standalone="yes"?>',
        '<Relationships xmlns="http://schemas.openxmlformats.org/',
        'package/2006/relationships">']);

      for i := 0 to Pictures.Count - 1 do
      begin
        // The extension must be "emf", regardless what the actual format is.
        s := Format('image-s%d-p%d%s', [m.Index, i + 1, '.emf'], SetFormat);

        Write(Format('<Relationship Id="rId%d" Type="http://schemas.' +
          'openxmlformats.org/officeDocument/2006/relationships/image"' +
          ' Target="../media/%s"/>', [i + 1, s], SetFormat));
        SaveGraphicAs(TfrxIEMObject(Pictures[i]).Metafile, IOTransport.TempFilter.GetStream(FDocFolder + 'xl/media/' + s), PictureType);
        TfrxIEMObject(Pictures[i]).UnloadImage;
      end;
      Write('</Relationships>');
      Free;
    end;
    IOTransport.TempFilter.FreeStream(TempStream);
    { xl/drawings/drawingXXX.xml }
    TempStream := IOTransport.TempFilter.GetStream(Format('%sxl/drawings/drawing%d.xml',
      [FDocFolder, m.Index]));
    with TfrxWriter.Create(TempStream) do
    begin
      Write(['<?xml version="1.0" encoding="UTF-8" standalone="yes"?>',
        '<xdr:wsDr xmlns:xdr="http://schemas.openxmlformats.org/drawingml',
        '/2006/spreadsheetDrawing" xmlns:a="http://schemas.openxmlformats.org/',
        'drawingml/2006/main">']);

      for i := 0 to Pictures.Count - 1 do
      begin
        r := FMatrix.GetObjectBounds(TfrxIEMObject(Pictures[i]));

        with TfrxIEMObject(Pictures[i]) do
          Write(['<xdr:twoCellAnchor><xdr:from><xdr:col>', IntToStr(GetCol(r.Left)),
            '</xdr:col><xdr:colOff>0</xdr:colOff><xdr:row>',
            IntToStr(GetRow(r.Top) - m.FirstRow),
            '</xdr:row><xdr:rowOff>0</xdr:rowOff></xdr:from><xdr:to><xdr:col>',
            IntToStr(GetCol(r.Right)), '</xdr:col><xdr:colOff>0</xdr:colOff>',
            '<xdr:row>', IntToStr(GetRow(r.Bottom) - m.FirstRow),
            '</xdr:row><xdr:rowOff>0',
            '</xdr:rowOff></xdr:to><xdr:pic><xdr:nvPicPr><xdr:cNvPr id="1025"',
            ' name="Picture 1"/><xdr:cNvPicPr><a:picLocks noChangeAspect="1"',
            ' noChangeArrowheads="1"/></xdr:cNvPicPr></xdr:nvPicPr><xdr:blipFill>',
            '<a:blip xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/',
            'relationships" r:embed="rId', IntToStr(i + 1), '"/><a:srcRect/><a:stretch>',
            '<a:fillRect/></a:stretch></xdr:blipFill><xdr:spPr bwMode="auto"><a:xfrm>',
            '<a:off x="0" y="0"/><a:ext cx="9525" cy="9525"/></a:xfrm><a:prstGeom',
            ' prst="rect"><a:avLst/></a:prstGeom><a:noFill/></xdr:spPr></xdr:pic>',
            '<xdr:clientData/></xdr:twoCellAnchor>']);
      end;

      for i := 0 to Pictures.Count - 1 do
        with TfrxIEMObject(Pictures[i]) do
          Write(['<xdr:twoCellAnchor editAs="absolute"><xdr:from><xdr:col>0</xdr:col>',
            '<xdr:colOff>0</xdr:colOff><xdr:row>0</xdr:row><xdr:rowOff>0</xdr:rowOff>',
            '</xdr:from><xdr:to><xdr:col>0</xdr:col><xdr:colOff>0</xdr:colOff>',
            '<xdr:row>0</xdr:row><xdr:rowOff>0</xdr:rowOff></xdr:to>',
            '<xdr:sp macro="" textlink=""><xdr:nvSpPr><xdr:cNvPr id="1024"',
            ' name="AutoShape 0"/><xdr:cNvSpPr><a:spLocks noChangeAspect="1"',
            ' noChangeArrowheads="1"/></xdr:cNvSpPr></xdr:nvSpPr><xdr:spPr bwMode="auto">',
            '<a:xfrm><a:off x="0" y="0"/><a:ext cx="0" cy="0"/></a:xfrm>',
            '<a:prstGeom prst="rect"><a:avLst/></a:prstGeom><a:noFill/></xdr:spPr>',
            '</xdr:sp><xdr:clientData fPrintsWithSheet="0"/></xdr:twoCellAnchor>']);

      Write('</xdr:wsDr>');
      Free;
    end;
    IOTransport.TempFilter.FreeStream(TempStream);
    Pictures.Free;
  end;

  { page setup }

  with TfrxWriter.Create(ss) do
  begin
    Write(Format('<pageMargins left="%f" right="%f" top="%f" bottom="%f"' +
      ' header="0" footer="0"/>', [m.Margins.Left * MarginFactor,
      m.Margins.Right * MarginFactor, m.Margins.Top * MarginFactor,
      m.Margins.Bottom * MarginFactor], SetFormat));

    Write([Format('<pageSetup paperSize="%d" firstPageNumber="0"' +
      ' orientation="%s" useFirstPageNumber="1" errors="blank"' +
      ' horizontalDpi="300" verticalDpi="300"/>', [m.PaperSize,
      Orientation(m.PageOrientation)]), '<headerFooter alignWithMargins="0"/>']);

    Free;
  end;

  { row breaks }

  if SingleSheet and (FMatrix.PagesCount < 1025) and FExportPageBreaks then
  begin
    StrList := TStringList.Create;
    j := 0;

    for i := m.FirstRow to m.LastRow do
      if FMatrix.GetCellYPos(i) >= FMatrix.GetPageBreak(j) then
      begin
        StrList.Add(Format('<brk id="%d" max="16383" man="1"/>', [i]));
        Inc(j);
      end;

    WriteStr(ss, Format('<rowBreaks count="%d" manualBreakCount="%d">',
      [StrList.Count, StrList.Count]));

    StrList.SaveToStream(ss);
    WriteStr(ss, '</rowBreaks>');
    StrList.Free;
  end;

  { drawing }

  if Pictures <> nil then
    WriteStr(ss, '<drawing r:id="rId1"/>');

  { ending }

  WriteStr(ss, '</worksheet>');

  { free resources }


   IOTransport.DoFilterSave(ss);
   IOTransport.FreeStream(ss);
  except
      on e: Exception do
        case Report.EngineOptions.NewSilentMode of
          simSilent:        Report.Errors.Add(e.Message);
          simMessageBoxes:  frxErrorMsg(e.Message);
          simReThrow:       raise;
        end;
  end;
end;

procedure TfrxXLSXExport.FinishPage(Page: TfrxReportPage; Index: Integer);
var
  m: TfrxMap;
begin
  m.Margins.Left := Page.LeftMargin;
  m.Margins.Right := Page.RightMargin;
  m.Margins.Top := Page.TopMargin;
  m.Margins.Bottom := Page.BottomMargin;
  m.PaperSize := Page.PaperSize;
  m.PageOrientation := Integer(Page.Orientation);

  FLastPage := m;

  with Page do
    FMatrix.AddPage(Orientation, Width, Height, LeftMargin,
      TopMargin, RightMargin, BottomMargin, MirrorMargins, Index);

  if (ChunkSize = 0) and not SingleSheet then
  begin
    FMatrix.Prepare;
    UpdateStyles;
    m.FirstRow := 0;
    m.LastRow := FMatrix.Height - 2;
    m.Index := Index + 1;
    AddSheet(m);
    FMatrix.Clear;
  end;
end;

procedure TfrxXLSXExport.UpdateStyles;
begin
  { <numFmts> section in xl/styles.xml }

  if FNumFmts.Count = 0 then
  FNumFmts.Add('<numFmt numFmtId="5" formatCode=' +
    '"#,##0&quot;R.&quot;;\-#,##0&quot;R.&quot;"/>');

  ExportFormats( FNumFmts );

  { <cellStyleXfs> section in xl/styles.xml }

  FCellStyleXfs.Add('<xf numFmtId="0" fontId="0" fillId="0" borderId="0">' +
    '<alignment horizontal="left" vertical="top" wrapText="1"/></xf>');

  { <cellXfs> section in xl/styles.xml }

  FCellXfs.Add('<xf numFmtId="0" fontId="0" fillId="0" borderId="0" xfId="0">' +
    '<alignment horizontal="left" vertical="top" wrapText="1"/></xf>');

  { <colors> section in xl/styles.xml }
  AddColors([$00000000, $00FFFFFF, $00FF0000, $0000FF00, $000000FF,
    $00FFFF00, $00FF00FF, $0000FFFF]);

  { <fills> section in xl/styles.xml }

  FFills.Add('<fill><patternFill patternType="none"/></fill>');
  FFills.Add('<fill><patternFill patternType="gray125"/></fill>');

  { <fonts> section in xl/styles.xml }

  FFonts.Add('<font><sz val="12"/><color rgb="FF000000"/><name val="Arial"/></font>');
end;

procedure TfrxXLSXExport.Finish;
var
  i: Integer;
  Zip: TfrxZipArchive;
  f: TStream;
  m: TfrxMap;
  FileNames: TStrings;
begin
  if SingleSheet then
  begin
    FMatrix.Prepare;
    UpdateStyles;
    m := FLastPage;
    m.FirstRow := 0;
    m.LastRow := FMatrix.Height - 2;
    m.Index := 1;
    AddSheet(m);
    FMatrix.Clear;
  end
  else if ChunkSize > 0 then
  begin
    FMatrix.Prepare;
    UpdateStyles;
    m := FLastPage;
    m.FirstRow := 0;
    m.Index := 1;

    while m.FirstRow < FMatrix.Height - 1 do
    begin
      m.LastRow := m.FirstRow + ChunkSize - 1;
      if m.LastRow > FMatrix.Height - 2 then
        m.LastRow := FMatrix.Height - 2;

      AddSheet(m);
      Inc(m.FirstRow, ChunkSize);
      Inc(m.Index);
    end;

    FMatrix.Clear;
  end;

  FMatrix.Free;
  try
    WriteStr(FContentTypes, '</Types>');
    WriteStr(FWorkbook, '</sheets><calcPr calcId="124519"/></workbook>');

    { xl/styles.xml }

    with TfrxWriter.Create(FStyles) do
    begin
      Write(['<styleSheet xmlns="http://schemas.openxmlformats.org/',
        'spreadsheetml/2006/main">']);

      Write('numFmts', FNumFmts);
      Write('fonts', FFonts);
      Write('fills', FFills);
      Write('borders', FBorders);
      Write('cellStyleXfs', FCellStyleXfs);
      Write('cellXfs', FCellXfs);

      Write(['<cellStyles count="1"><cellStyle name="Normal" xfId="0"',
        ' builtinId="0"/></cellStyles><dxfs count="0"/>',
        '<tableStyles count="0" defaultTableStyle="TableStyleMedium9"',
        ' defaultPivotStyle="PivotStyleLight16"/>',
        '<colors><indexedColors>']);

      for i := 0 to FColors.Count - 1 do
        Write('<rgbColor rgb="%x"/>', [Integer(FColors[i])]);

      Write('</indexedColors></colors></styleSheet>');
      Free;
    end;

    { xl/sharedStrings.xml }

    with TfrxWriter.Create(FSharedStrings) do
    begin
      Write('<sst xmlns="http://schemas.openxmlformats.org/' +
        'spreadsheetml/2006/main" count="%d" uniqueCount="%d">',
        [FStringsCount, FStrings.Count]);

      for i := 0 to FStrings.Count - 1 do
      begin
        Write('<si><t xml:space="preserve">');
        // note: in unicode delphi12+ Utf8Encode has no effect: when converted to widestring it does utf8decode automatically
        Write(Copy(FStrings[i], 1, length(FStrings[i]) - 2), {$IFDEF Delphi12}True{$ELSE}False{$ENDIF});
        Write('</t></si>');
      end;

      Write('</sst>');
      Free;
    end;

    { xl/_rels/workbook.xml.rels }

    WriteStr(FWorkbookRels, '</Relationships>');

    { free resources }

  FFonts.Free;
  FFills.Free;
  FBorders.Free;
  FCellXfs.Free;
  FCellStyleXfs.Free;
  FColors.Free;
  FNumFmts.Free;
  FStrings.Free;
  FileNames := TStringList.Create;
  { close files }
  IOTransport.TempFilter.FilterAccess := faRead;
  IOTransport.TempFilter.LoadClosedStreams;
  FileNames.Clear;
  IOTransport.TempFilter.CopyStreamsNames(FileNames, True);

  { compress data }

  if Assigned(Stream) then
    f := Stream
  else
    try
      f := IOTransport.GetStream(FileName);
    except
      f := nil;
    end;
  if Assigned(f) then
  begin
    Zip := TfrxZipArchive.Create;
    try
      Zip.RootFolder := AnsiString(FDocFolder);
//      Zip.AddDir(AnsiString(FDocFolder));
      Zip.SaveToStreamFromList(f, FileNames);
//      Zip.SaveToStream(f);
    finally
      Zip.Free;
    end;
  end;

  if not Assigned(Stream) then
  begin
    IOTransport.DoFilterSave(f);
    IOTransport.FreeStream(f);
  end;
  FileNames.Free;
  except
      on e: Exception do
        case Report.EngineOptions.NewSilentMode of
          simSilent:        Report.Errors.Add(e.Message);
          simMessageBoxes:  frxErrorMsg(e.Message);
          simReThrow:       raise;
        end;
  end;
end;

initialization
  SetFormat.DecimalSeparator := '.';

end.
