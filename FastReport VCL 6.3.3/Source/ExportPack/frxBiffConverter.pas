
{******************************************}
{                                          }
{             FastReport v5.0              }
{   Converter from TfrxIEMatrix to BIFF    }
{                                          }
{         Copyright (c) 1998-2011          }
{           by Anton Khayrudinov           }
{             Fast Reports Inc.            }
{                                          }
{******************************************}

unit frxBiffConverter;

{$I frx.inc}

interface

uses
  Graphics,
  Windows,
  Classes,
{$IFDEF DELPHI16}
 System.UITypes,
{$ENDIF}
  frxClass,
  frxExportMatrix,
  frxBIFF,

  frxProgress,
  frxGraphicUtils;

{ Printers.TPrinterOrientation
  This type is not defined in Delphi4, therefore
  I have to define these constants manually. }

const
  frxPoPortrait = 0;  // poPortrait
  frxPoLandscape = 1; // poLandscape

type

  TfrxPrintOrient = LongInt; // Printers.TPrinterOrientation

  { Fields of this structure are
    copies of corresponding fields
    from TfrxReportPage. }

  TfrxPageInfo = record

    PaperWidth:   Extended;
    PaperHeight:  Extended;
    LeftMargin:   Extended;
    RightMargin:  Extended;
    TopMargin:    Extended;
    BottomMargin: Extended;
    Orientation:  TfrxPrintOrient;
    PageCount:    LongInt;
    PaperSize:    LongInt;
    Name:         string;

  end;

  { - Matrix  - the exported data matrix
    - Sheet   - the resulting Excel sheet
    - Workbook- a workbook that will contain the sheet
    - Page    - the current page
    - PageId  - index to the page
    - Size    - count of columns and rows in the mapped rectangle area
    - Source  - the top-left cell in TfrxIEMatrix
    - Dest    - the top-left cell in the Excel sheet
    - Images  - list of indexes to TfrxIEMObject with pictures
    - Surr    - if set, empty cells will be added for padding
    - Pictures - if set, pictures are exported
    - PageBreaks - if set, pages breaks are added to Excel sheet
    - FitPages - adjust page dimensions to fit to a print page
    - TSW     - with of a tab offset
    - ZCW     - width of zero character
    - GridLines - if set, the sheet will contain grid lines }

  TfrxBiffPageOptions = record
    Matrix:   TfrxIEMatrix;
    Sheet:    TBiffSheet;
    Page:     TfrxPageInfo;
    PageId:   LongInt;
    Source:   TPoint;
    Dest:     TPoint;
    Size:     TPoint;
    Images:   TList;
    Surr:     Boolean;
    Pictures: Boolean;
    PageBreaks: Boolean;
    WorkBook: TBiffWorkbook;
    FitPages: Boolean;
    TSW:      Integer;
    ZCW:      Integer;
    GridLines: Boolean;
    RHScale:  Extended;
    Formulas: Boolean;
  end;

  { Any object in the matrix has a style.
    This style must be converted to XF record
    that can be written to a BIFF document.
    The conversion is slow, so it need be cached. }

  TfrxBiffStyles = class
  private

    FXFi: array of Integer;   // XF indexes
    FFonti: array of Integer; // Font indexes
    FFonts: array of TFont;   // TFont objects
    FWorkbook: TBiffWorkbook;
    FTSW: Integer;            // the width of the tab character

    { Creates an XF record and returns an index to this record.
      Excel defines XF records of two types: cell XFs and style XFs.
      This function creates a cell XF record. }

    function CreateStyle(s: TfrxIEMStyle; BgPattern: Boolean;
      RTL: Boolean): LongInt;

    { Returns an index to an entry in FXFi that corresponds
      to the given arguments. }

    function GetEntryIndex(StyleIndex: Integer; Background, RTL: Boolean): Integer;

    { Returns True if the style index is valid }

    function IsValidStyleIndex(StyleIndex: Integer): Boolean;

  public

    { StylesCount - the maximum number of styles that will be added via AddStyle
      Workbook    - the workbook that will keep all added styles and fonts
      TSW         - the width of the tab character }

    constructor Create(StylesCount: Integer; Workbook: TBiffWorkbook; TSW: Integer);

    { Creates an XF record from the given style object and
      two boolean constants. The created XF record is associated
      with the given style index. The routine returns an index
      to the created XF record. }

    function AddStyle(StyleIndex: Integer; Style: TfrxIEMStyle;
      Background, RTL: Boolean): Integer;

    { Returns an index to a previously created XF record }

    function GetStyle(StyleIndex: Integer; Background, RTL: Boolean): Integer;

    { Creates a FONT record, adds it to a workbook and
      returns an index to the added FONT record. }

    function CreateFont(f: TFont; ss: TSubStyle = ssNormal): LongInt;

    { Creates a FONT recor from the given font object.
      The result is an index to the created FONT record. }

    function AddFont(Font: TFont): Integer;

    { Returns an index to a FONT record previously
      created via AddFont. If AddFont hasn't been
      called for this font object, then -1 is returned. }

    function GetFont(Font: TFont): Integer;
  end;

  TfrxBiffConverter = class
  private

    po: TfrxBiffPageOptions;
    FShowprogress: Boolean;
    FProgressBar: TfrxProgress;

    procedure Convert(Sheet: TBiffSheet; BiffMaxRow_: Longint = BiffMaxRow);

    procedure InitProgressBar(Steps: Integer; Text: string);
    procedure StepProgressBarIf(Condition: Boolean);
    procedure FreeProgressBar;

    procedure BreakIfTerminated;

    //
    // todo: any cell text seems to end with a line break
    // even no line breaks are written in the designer.
    // This will suppress the ending system symbols.
    //

    procedure SuppressEndingTrash(var s: WideString);

    function CreateFormulaCell(Obj: TfrxIEMObject): TBiffCell;
    function CreateHTMLCell(obj: TfrxIEMObject; Styles: TfrxBiffStyles): TBiffTextCell;
    function CreateTextCell(obj: TfrxIEMObject): TBiffCell;
    function CreateNumberCell(obj: TfrxIEMObject): TBiffCell;
    function CreateDateCell(obj: TfrxIEMObject): TBiffCell;
    function CreateCell(r, c: LongInt; obj: TfrxIEMObject; Styles: TfrxBiffStyles): TBiffCell;

    function IsFormula(Obj: TfrxIEMObject): Boolean;

    procedure SetColWidths(s: TBiffSheet);
    procedure SetRowHeights(s: TBiffSheet);
    procedure SetMargin(var m: TBiffMargin); // page margin in inches
    procedure SetPageSetup(ps: TBiffPageSetup);
    procedure AddImage(Sheet: TBiffSheet; ObjId: LongInt);
    procedure MergeCells(Sheet: TBiffSheet; ObjId: Integer);

    { Ratio of a length unit of an Excel column width to a pixel.
      Example:

      w := 300; // 300 pixels
      cw := w * GetColWidthFactor; // excel column's width is 300 pixels }

    function GetColWidthFactor: Double;

    { Ratio of a length unit of an Excel row height to a pixel.
      Example:

      h := 200; // 200 pixels
      rh := h * GetRowHeightFactor; // excel row's height is 200 pixels }

    function GetRowHeightFactor: Double;

    { Returns the width of a column in units
      defined in [MS-XLS] }

    function GetColWidth(Col: LongInt): Double;

    { Returns the height of a row in units
      defines in [MS-XLS] }

    function GetRowHeight(Row: LongInt): Double;

  public

    function GetSheet(BiffMaxRow_: Longint = BiffMaxRow): TBiffSheet;

    property Options: TfrxBiffPageOptions write po;
    property ShowProgress: Boolean read FShowProgress write FShowProgress;

  end;

  ETerminated = class(TObject);       // exporting terminated
  EInvalidFRFormat = class(TObject);  // invalid FR number format

function frxConvertMatrixToBiffSheet(po: TfrxBiffPageOptions;
  ShowProgress: Boolean;
  BiffMaxRow_: Longint = BiffMaxRow): TBiffSheet;

implementation

uses
  frxRes,
  frxImageConverter,
  frxEscher,
  SysUtils;

function ResStr(Tag: string): string;
begin
  Result := frxResources.Get(Tag)
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

function frxConvertMatrixToBiffSheet(po: TfrxBiffPageOptions; ShowProgress: Boolean; BiffMaxRow_: Longint = BiffMaxRow): TBiffSheet;
var
  Conv: TfrxBiffConverter;
begin
  Conv := TfrxBiffConverter.Create;

  try
    Conv.ShowProgress := ShowProgress;
    Conv.Options := po;

    Result := Conv.GetSheet(BiffMaxRow_);
  finally
    Conv.Free;
  end;
end;

function DupChar(c: Char; n: Integer): string;
var
  i: Integer;
begin
  SetLength(Result, n);

  for i := 1 to n do
    Result[i] := c;
end;

{ TfrxBiffConverter }

procedure TfrxBiffConverter.SuppressEndingTrash(var s: WideString);
begin
  if Copy(s, Length(s) - 1, 2) = #13#10 then
    s := Copy(s, 1, Length(s) - 2)
end;

function TfrxBiffConverter.CreateHTMLCell(obj: TfrxIEMObject;
  Styles: TfrxBiffStyles): TBiffTextCell;
var
  orig:     WideString;   // Cell text
  text:     WideString;   // Buffer
  ucs:      TBiffUCS;     // BIFF8 string
  textLen:  LongInt;      // Length(text)
  curTag:   TfrxHTMLTag;  // Currently opened HTML tag
  curStr:   WideString;
  curLen:   LongInt;

  function Eq(a, b: TfrxHTMLTag): Boolean;
  begin
    if (a = nil) and (b = nil) then
      Result := True
    else if (a = nil) or (b = nil) then
      Result := False
    else
      Result :=
        (a.Style = b.Style) and
        (a.Color = b.Color) and
        (a.SubType = b.SubType);
  end;

  procedure PushChar(Pos: LongInt);
  var
    c: WideChar;
  begin
    c := orig[Pos];
    if c = #13 then Exit;
    curStr := curStr + c;
    Inc(curLen);
  end;

  procedure ResetCurTag;
  begin
    curTag := nil;
    curStr := '';
    curLen := 0;
  end;

  //
  // Creates a FONT record and returns its index.
  //

  function TagToFont(tag: TfrxHTMLTag): LongInt;
  var
    font: TFont;
  begin
    font := TFont.Create;
    font.Assign(obj.Style.Font);

    with font do
    begin
      Color := tag.Color;
      Style := tag.Style;
    end;

    Result := Styles.CreateFont(font, tag.SubType);
    font.Free;
  end;

  //
  // Adds a formatting run defined by the current tag (cur).
  //

  procedure AddFormat;
  begin
    if curTag = nil then Exit;
    ucs.AddFormat(textLen, TagToFont(curTag));
    text := text + curStr;
    Inc(textLen, curLen);
  end;

var
  list:       TfrxHTMLTagsList;
  tags:       TfrxHTMLTags;
  tag:        TfrxHTMLTag;
  i, j, sst:  LongInt;

begin
  text    := obj.Memo.Text;
  textLen := Length(text);

  list := TfrxHTMLTagsList.Create;
  list.AllowTags := True;

  with obj.Style.Font do
    list.SetDefaults(Color, 0, Style);

  orig := text;
  list.ExpandHTMLTags(text);

  text := '';
  textLen := 0;

  ResetCurTag;
  ucs := TBiffUCS.Create;

  for i := 0 to list.Count - 1 do
  begin
    tags := list[i];
    for j := 0 to tags.Count - 1 do
    begin
      tag := tags[j];

      if not Eq(tag, curTag) then
      begin
        AddFormat;
        ResetCurTag;
        curTag := tag;
      end;

      PushChar(tag.Position);
    end;
  end;

  AddFormat;
  list.Free;
  SuppressEndingTrash(text);

  with ucs do
  begin
    Data  := text;
    Len16 := True;
  end;

  sst := po.WorkBook.AddString(ucs);
  Result := TBiffTextCell.Create(sst);
end;

function TfrxBiffConverter.CreateTextCell(obj: TfrxIEMObject): TBiffCell;
var
  sst:  LongInt;
  text: WideString;

begin
  text := obj.Memo.Text;
  SuppressEndingTrash(text);

  if text = '' then
  begin
    Result := TBiffCell.Create;
    Exit;
  end;

  ValidateLineBreaks(text);

  sst     := po.WorkBook.AddString(text);
  Result  := TBiffTextCell.Create(sst)
end;

{$HINTS OFF}
function TfrxBiffConverter.CreateFormulaCell(Obj: TfrxIEMObject): TBiffCell;
var
  Compiler: TBiffFormulaCompiler;
  Stream: TStream;
begin
  Compiler := TBiffFormulaCompiler.Create;

  try
    try
      Compiler.LinkTable := po.WorkBook.LinkTable;

      with Obj.Memo do
        if Copy(Text, 1, 1) = '=' then
          Compiler.Formula := Copy(Text, 2, Length(Text) - 1)
        else
          Compiler.Formula := Text;

      Stream := TMemoryStream.Create;

      try
        Compiler.SaveToStream(Stream);
      except
        Stream.Free;
        Result := nil;
        raise
      end;

      Result := TBiffFormulaCell.Create(Stream);
    finally
      Compiler.Free;
    end;
  except
    Result := CreateTextCell(Obj);
  end;
end;
{$HINTS ON}

function TfrxBiffConverter.CreateNumberCell(obj: TfrxIEMObject): TBiffCell;

  function Clean(const s: AnsiString): AnsiString;
  var
    i, j: Integer;
  begin
    SetLength(Result, Length(s));
    j := 1;

    for i := 1 to Length(s) do
      if s[i] in ['0'..'9'] then
      begin
        Result[j] := s[i];
        Inc(j);
      end;

    SetLength(Result, j - 1);
  end;

  function CleanText(const s: AnsiString; Sep: AnsiChar): AnsiString;
  var
    i, j: Integer;
  begin
    SetLength(Result, Length(s));
    j := 1;

    for i := 1 to Length(s) do
      if s[i] in ['0'..'9', Sep] then
      begin
        Result[j] := s[i];
        Inc(j);
      end;

    SetLength(Result, j - 1);
  end;

  function CleanExp(const s: AnsiString; Sep: AnsiChar): AnsiString;
  var
    i, j: Integer;
    Exp, ExpSign: Boolean;
  begin
    SetLength(Result, Length(s));
    j := 1;
    Exp := False;
    ExpSign := False;

    for i := 1 to Length(s) do
      if s[i] in ['-', '+', '0'..'9', 'e', 'E', Sep] then
      begin
        if s[i] in ['e', 'E'] then
          begin
            if not Exp then Exp := True else Continue;
          end;
        if Exp then
          begin
            if s[i] in ['-', '+'] then if not ExpSign then ExpSign := True else Continue;
          end
        else
         if s[i] = '+' then Continue;
        if s[i] = Sep then
          Result[j] := AnsiChar(GetSystemDecimalSeparator)
        else
          Result[j] := s[i];
        Inc(j);
      end;

    SetLength(Result, j - 1);
  end;

  function Pos(const s: AnsiString; c: AnsiChar): Integer;
  begin
    for Result := 1 to Length(s) do
      if s[Result] = c then
        Exit;

    Result := 0;
  end;

  function FracPart(const s: AnsiString): Extended;
  var
    i: Integer;
  begin
    Result := 0;

    for i := Length(s) downto 1 do
      Result := (Result + Ord(s[i]) - Ord('0'))*0.1
  end;

  function IntPart(const s: AnsiString): Extended;
  var
    i: Integer;
  begin
    Result := 0;

    for i := 1 to Length(s) do
      Result := Result*10 + Ord(s[i]) - Ord('0')
  end;

var
  Text:   AnsiString;
  Sep:    AnsiChar;
  ip, fp: Extended;
  Sign:   Extended;
  i:      Integer;

begin
  Result := nil;
  Text := AnsiString(obj.Memo.Text);

  if Text = '' then
    Exit;

  with obj.Style.DisplayFormat do
    if DecimalSeparator <> '' then
      Sep := AnsiChar(DecimalSeparator[1])
    else
      Sep := AnsiChar(GetSystemDecimalSeparator);

  if (Text[1] = '-') or (Text[1] = '(') then
    Sign := -1
  else
    Sign := +1;

  if (Pos(Text, 'e') <> 0) or (Pos(Text, 'E') <> 0) then
    begin
      try
        Result := TBiffNumberCell.Create(StrToFloat(string(CleanExp(Text, Sep))));
      except
        Result := TBiffNumberCell.Create(StrToFloat(string(CleanText(Text, Sep))));
      end
    end
  else
    begin
      i := Pos(Text, Sep);

      if i = 0 then
      begin
        ip := IntPart(Clean(Text));
        fp := 0;
      end
      else
      begin
        ip := IntPart(Clean(Copy(Text, 1, i - 1)));
        fp := FracPart(Clean(Copy(Text, i + 1, Length(Text) - i)));
      end;

      Result := TBiffNumberCell.Create(Sign*(ip + fp));
    end;
end;

function TfrxBiffConverter.CreateDateCell(obj: TfrxIEMObject): TBiffCell;
var
{$IFDEF DELPHI12}
  Text: String;
{$ELSE}
  Text: AnsiString;
{$ENDIF}
  D: TDateTime;
  FS: TFormatSettings;
begin
  Result := nil;
{$IFDEF DELPHI12}
  Text := String(obj.Memo.Text);
{$ELSE}
  Text := AnsiString(obj.Memo.Text);
{$ENDIF}
  if Text = '' then
    Exit;
  GetLocaleFormatSettings(GetUserDefaultLCID, FS);
  Text := StringReplace(Text, '/', '.', [rfReplaceAll]); //add
  FS.DateSeparator := '.';
  FS.TimeSeparator := ':';
  FS.ShortDateFormat := 'dd.mm.yyyy';
  FS.ShortTimeFormat := 'hh:nn:ss';
  //D := StrToDateTimeDef(Text, Now, FS);
  try
    D := StrToDateTime(Trim(Text), FS);
    Result := TBiffNumberCell.Create(d);
  except
    Result := nil;
  end;
  //Result := TBiffNumberCell.Create(d);
end;

function TfrxBiffConverter.CreateCell(r, c: LongInt; obj: TfrxIEMObject;
  Styles: TfrxBiffStyles): TBiffCell;
var
  cell: TBiffCell;
  img: Boolean;
begin
  if obj = nil then
  begin
    Result := TBiffCell.Create;

    with Result do
    begin
      Row := r;
      Col := c;
      XF  := 15;
    end;

    Exit;
  end;

  cell := nil;

  if obj.Counter > 1 then
    cell := TBiffCell.Create // Blank cell (cell without text)

  else if IsFormula(obj) then
    cell := CreateFormulaCell(obj)

  else if obj.HTMLTags then
    cell := CreateHTMLCell(obj, Styles) // Text cell with formatting runs

  else if obj.Style.DisplayFormat.Kind = fkNumeric then
    cell := CreateNumberCell(obj)

  else if (obj.Style.DisplayFormat.Kind = fkDateTime) then //added support for datetime
    cell := CreateDateCell(obj);

  if cell = nil then
    cell := CreateTextCell(obj); // Cell with plain text (without HTML formatting)

  img := (obj.Metafile <> nil) and
    (obj.Metafile.Width <> 0) and (obj.Metafile.Height <> 0);

  with cell do
  begin
    Row   := r;
    Col   := c;
    XF    := Styles.AddStyle(obj.StyleIndex, obj.Style, not img, obj.RTL);
  end;

  Result := cell;
end;

function TfrxBiffConverter.GetColWidthFactor: Double;
begin
  Result := 96 * 256 / (72 * po.ZCW);
end;

function TfrxBiffConverter.GetRowHeightFactor: Double;
begin
  Result := 72 * 20 / 96;
end;

function TfrxBiffConverter.GetColWidth(Col: LongInt): Double;
begin
  with po.Matrix do
  begin
    if Col < Width - 1 then
      Result := GetXPosById(Col + 1)
    else with po.Page do
      Result := (PaperWidth - RightMargin) / 25.4 * 96;

    Result := Round(Result - GetXPosById(Col));
    Result := Result * GetColWidthFactor;
    if Result < 0 then Result := 0;
  end;
end;

function TfrxBiffConverter.GetRowHeight(Row: LongInt): Double;
begin
  with po.Matrix do
  begin

    { todo: There's a bug somewhere in TfrxIEMatrix.
      GetXPosById(0) returns a distance between the left
      side of the page and the left side of the leftmost
      object. GetYPosById(0) returns a distance between
      the top side of the page and the top side of the
      topmost object MINUS the top margin. }

    if Row < Height - 1 then
      Result := GetYPosById(Row + 1)
    else with po.Page do
      Result := (PaperHeight - BottomMargin - TopMargin) / 25.4 * 96;

    Result := Round(Result - GetYPosById(Row));
    Result := Result * GetRowHeightFactor;
    if Result < 0 then Result := 0;
  end;
end;

procedure TfrxBiffConverter.SetColWidths(s: TBiffSheet);
const
  ColBlock: Integer = 100;
var
  i: LongInt;
  w: Double;
begin
  if po.Size.X = 0 then Exit;

  { Calculate the scaling factor w. }

  if not po.FitPages then
    w := 1.0
  else
  begin
    try
      with po.Matrix do
        w := GetXPosById(po.Source.X + po.Size.X) - GetXPosById(po.Source.X);
    except
      w := 2.09;
    end;

    w := w + po.Size.X; // inaccuracy that can occur
    w := w / 96 * 25.4; // convert to millimeters

    with po.Page do
      if w > 0.0 then
        w := (PaperWidth - (LeftMargin + RightMargin)) / w
      else
        w := 1.0;

    if w > 1.0 then w := 1.0;
  end;

  InitProgressBar(po.Size.X div ColBlock, ResStr('BiffCol'));

  try
    for i := 0 to po.Size.X - 1 do
    begin
      s.ColWidth[po.Dest.X + i] := Round(w * GetColWidth(po.Source.X + i));
      StepProgressBarIf(i mod ColBlock = 0);
      BreakIfTerminated;
    end;
  finally
    FreeProgressBar;
  end;
end;

procedure TfrxBiffConverter.SetRowHeights(s: TBiffSheet);
const
  RowBlock: Integer = 100;
var
  i: LongInt;
  h: Extended;
begin
  if po.Size.Y = 0 then Exit;

  { h = a ratio of the paper height to the summary height
        of all cells in the exported matrix.

    Normally, h >= 1.0. But if the original report is bad
    aligned, the formed matrix can be larger than the paper
    and h < 1.0. This means that all cells should be shrinked
    to fit to the paper. }

  if not po.FitPages or po.PageBreaks then
    h := 1.0
  else
  begin
    with po.Matrix do
      h := GetYPosById(po.Source.Y + po.Size.Y) - GetYPosById(po.Source.Y);

    h := h + 2 + po.Size.Y; // inaccuracy that can occur
    h := h / 96 * 25.4;     // convert to millimeters

    with po.Page do
      if h > 0.0 then
        h := (PaperHeight - (TopMargin + BottomMargin)) / h
      else
        h := 0.0;

    if h > 1.0 then h := 1.0;
  end;

  InitProgressBar(po.Size.Y div RowBlock, ResStr('BiffRow'));

  try
    for i := 0 to po.Size.Y - 1 do
    begin
      s.RowHeight[po.Dest.Y + i] := Round(po.RHScale * h * GetRowHeight(po.Source.Y + i));
      StepProgressBarIf(i mod RowBlock = 0);
      BreakIfTerminated;
    end;
  finally
    FreeProgressBar;
  end;
end;

procedure TfrxBiffConverter.SetMargin(var m: TBiffMargin);

  function f2i(x: Extended): Double;
  begin
    Result := x / 25.4;
  end;

begin
  with po.Page do
  begin
    m.Left    := f2i(LeftMargin);
    m.Top     := f2i(TopMargin);
    m.Right   := f2i(RightMargin);
    m.Bottom  := f2i(BottomMargin);
  end;
end;

procedure TfrxBiffConverter.SetPageSetup(ps: TBiffPageSetup);

  function GetOrientation(o: TfrxPrintOrient): TBiffPageOrientation;
  begin
    Result := bpoPortrait;
    if LongInt(o) = frxPoLandscape then
      Result := bpoLandscape;
  end;

  function GetPaperSize(s: LongInt): Word;
  begin
    if (s = BiffPsUnknown) or (s >= BiffPsReservedMin) and
      (s <= BiffPsReservedMax) or (s >= BiffPsCustomMin) then
      Result := BiffPsA4
    else
      Result := s;
  end;

begin
  ps.Orient := GetOrientation(po.Page.Orientation);
  ps.Size   := GetPaperSize(po.Page.PaperSize);
  ps.Copies := po.Page.PageCount;
end;

procedure TfrxBiffConverter.AddImage(Sheet: TBiffSheet; ObjId: LongInt);
var
  LeftCol, TopRow, Cols, Rows: Integer; // object's bounds
  Obj: TfrxIEMObject;
  Stream: TStream;
begin
  Obj := po.Matrix.GetObjectById(ObjId);

  if (Obj = nil) or
     (Obj.Metafile = nil) or
     (Obj.Metafile.Width = 0) or
     (Obj.Metafile.Height = 0) then
     Exit;

  po.Matrix.GetObjectPos(ObjId, LeftCol, TopRow, Cols, Rows);

  if  (LeftCol < po.Dest.X) or
      (TopRow < po.Dest.Y) or
      (LeftCol + Cols > po.Dest.X + po.Size.X) or
      (TopRow + Rows > po.Dest.Y + po.Size.Y) then
    Exit;

  with Sheet.AddDrawing do
  begin
    Stream := TMemoryStream.Create;

    try
      SaveGraphicAs(Obj.Metafile, Stream, gpPNG);
      Image := po.WorkBook.AddBitmap(EscherBkPNG, Stream);
    finally
      Stream.Free;
    end;

    with Pos do
    begin
      Left    := LeftCol;
      Top     := TopRow;
      Right   := LeftCol + Cols;
      Bottom  := TopRow + Rows;
    end;
  end;
end;

procedure TfrxBiffConverter.Convert(Sheet: TBiffSheet; BiffMaxRow_: Longint = BiffMaxRow);
var
  r, c:     Integer;
  obj:      TfrxIEMObject;
  id:       LongInt;
  CurPage:  Integer;
  Styles:   TfrxBiffStyles;
begin
  { If the entire report is exported to a single
    sheet, it's needed to add page breaks. CurPage
    is the current page index. }

  CurPage := po.PageId;

  if po.Page.Name = '' then
    Sheet.Name := frxGet(9154) + ' ' + IntToStr(po.PageId)
  else
    Sheet.Name := po.Page.Name;

  if not po.GridLines then
    Sheet.View.Options := Sheet.View.Options and not BiffWoGridLines;

  SetMargin(Sheet.Margin);
  SetPageSetup(Sheet.PageSetup);

  { Correct the mapped cells area }

  with po do
  begin
    with Source do
    begin
      if X < 0 then X := 0;
      if Y < 0 then Y := 0;
    end;

    with Dest do
    begin
      if X < 0 then X := 0;
      if Y < 0 then Y := 0;

      if Surr then
      begin
        Inc(X);
        Inc(Y);
      end;
    end;

    with Size do
    begin
      if X = 0 then X := BiffMaxCol + 1;
      if Y = 0 then Y := BiffMaxRow_ + 1;

      if Source.X + X > Matrix.Width - 1 then
        X := Matrix.Width - 1 - Source.X;

      if Source.Y + Y > Matrix.Height - 1 then
        Y := Matrix.Height - 1 - Source.Y;

      if Source.X + X > BiffMaxCol + 1 then
        X := BiffMaxCol + 1 - Source.X;

      if Source.Y + Y > BiffMaxRow_ + 1 then
        Y := BiffMaxRow_ + 1 - Source.Y;

      if X < 0 then
        X := 0;

      if Y < 0 then
        Y := 0;
    end;
  end;

  { Export cells }

  Styles := TfrxBiffStyles.Create(po.Matrix.GetStylesCount, po.WorkBook, po.TSW);
  InitProgressBar(po.Size.Y div 128, ResStr('BiffCell'));

  try
    with po.Matrix do
      for r := 0 to po.Size.Y - 1 do
      begin
        with po.Source do
          if po.PageBreaks and (GetCellYPos(Y + r) > GetPageBreak(CurPage)) and (CurPage < 1025) then
          begin
            Sheet.AddPageBreak(po.Dest.Y + r);
            Inc(CurPage);
          end;

        for c := 0 to po.Size.X - 1 do
        begin
          with po.Source do
            id := GetCell(X + c, Y + r);

          if id < 0 then
            Continue;

          obj := GetObjectById(id);
          obj.Counter := obj.Counter + 1;

          with po.Dest do
            Sheet.AddCell(CreateCell(Y + r, X + c, obj, Styles));

          if obj.Counter = 1 then
            MergeCells(Sheet, id);

          BreakIfTerminated;
        end;

        StepProgressBarIf(r mod 128 = 0);
      end;
  finally
    Styles.Free;
    FreeProgressBar;
  end;

  { Set cell sizes }

  SetColWidths(Sheet);
  SetRowHeights(Sheet);

  { Export pictures }

  if po.Pictures then
    if po.Images = nil then
      with po.Matrix do
        try
          InitProgressBar(ObjectsCount div 128, ResStr('BiffImg'));

          for id := 0 to GetObjectsCount - 1 do
          begin
            AddImage(Sheet, id);
            StepProgressBarIf(id mod 128 = 0);
            BreakIfTerminated;
          end;
        finally
          FreeProgressBar
        end
    else
      with po.Images do
        try
          InitProgressBar(Count div 128, ResStr('BiffImg'));

          for id := 0 to Count - 1 do
          begin
            AddImage(Sheet, LongInt(Items[id]));
            StepProgressBarIf(id mod 128 = 0);
            BreakIfTerminated;
          end;
        finally
          FreeProgressBar
        end;
end;

function TfrxBiffConverter.GetSheet(BiffMaxRow_: Longint = BiffMaxRow): TBiffSheet;
begin
  Result := TBiffSheet.Create(po.WorkBook);

  try
    Convert(Result, BiffMaxRow_)
  except
    on ETerminated do
      { do nothing }
    else
    begin
      Result.Free;
      raise;
    end
  end
end;

procedure TfrxBiffConverter.InitProgressBar(Steps: Integer; Text: string);
begin
  if ShowProgress then
  begin
    FProgressBar := TfrxProgress.Create(nil);
    FProgressBar.Execute(Steps, frxResources.Get('ProgressWait'), True, True);
    FProgressBar.Message := Text;
  end;
end;

function TfrxBiffConverter.IsFormula(Obj: TfrxIEMObject): Boolean;
begin
  Result := po.Formulas and (Copy(Obj.Memo.Text, 1, 1) = '=')
end;

procedure TfrxBiffConverter.MergeCells(Sheet: TBiffSheet; ObjId: Integer);
var
  x, y, dx, dy: Integer;
begin
  po.Matrix.GetObjectPos(ObjId, x, y, dx, dy);
  Sheet.MergeCells(Rect(x, y, x + dx - 1, y + dy - 1));
end;

procedure TfrxBiffConverter.StepProgressBarIf(Condition: Boolean);
begin
  if ShowProgress and Condition then
    FProgressBar.Tick
end;

procedure TfrxBiffConverter.FreeProgressBar;
begin
  FProgressBar.Free
end;

procedure TfrxBiffConverter.BreakIfTerminated;
begin
  if ShowProgress and FProgressBar.Terminated then
    raise ETerminated.Create
end;

{ TfrxBiffStyles }

constructor TfrxBiffStyles.Create(StylesCount: Integer; Workbook: TBiffWorkbook;
  TSW: Integer);
var
  i: Integer;
begin
  FTSW := TSW;
  SetLength(FXFi, 4 * StylesCount);
  FWorkbook := Workbook;

  for i := 0 to Length(FXFi) - 1 do
    FXFi[i] := -1;
end;

function TfrxBiffStyles.IsValidStyleIndex(StyleIndex: Integer): Boolean;
begin
  Result := (StyleIndex >= 0) and (StyleIndex * 4 < Length(FXFi));
end;

function TfrxBiffStyles.GetEntryIndex(StyleIndex: Integer;
  Background, RTL: Boolean): Integer;
begin
  Result := StyleIndex * 4;

  if Background then
    Inc(Result);

  if RTL then
    Inc(Result, 2);
end;

function TfrxBiffStyles.AddStyle(StyleIndex: Integer; Style: TfrxIEMStyle;
  Background, RTL: Boolean): Integer;
var
  i: Integer;
begin
  Result := GetStyle(StyleIndex, Background, RTL);

  if Result >= 0 then
    Exit;

  Result := CreateStyle(Style, Background, RTL);
  i := GetEntryIndex(StyleIndex, Background, RTL);
  FXFi[i] := Result;
end;

function TfrxBiffStyles.GetStyle(StyleIndex: Integer; Background, RTL: Boolean): Integer;
var
  i: Integer;
begin
  if not IsValidStyleIndex(StyleIndex) then
    raise Exception.Create('StyleIndex is out of bounds');

  i := GetEntryIndex(StyleIndex, Background, RTL);
  Result := FXFi[i];
end;

function TfrxBiffStyles.AddFont(Font: TFont): Integer;
var
  n: Integer;
begin
  Result := GetFont(Font);
  if Result >= 0 then
    Exit;

  Result := CreateFont(Font);

  n := Length(FFonts);

  SetLength(FFonts, n + 1);
  SetLength(FFonti, n + 1);

  FFonts[n] := Font;
  FFonti[n] := Result;
end;

function TfrxBiffStyles.GetFont(Font: TFont): Integer;
var
  i: Integer;
begin
  for i := 0 to Length(FFonts) - 1 do
    if FFonts[i] = Font then
    begin
      Result := FFonti[i];
      Exit;
    end;

  Result := -1;
end;

function TfrxBiffStyles.CreateFont(f: TFont; ss: TSubStyle): LongInt;
var
  font: TBiffFont;

  procedure AddOption(opt: TBiffFontOptions);
  begin
    font.Data.Options := font.Data.Options or Word(opt);
  end;

  function GetWeight: Word;
  begin
    Result := Word(fwNormal);
    if fsBold in f.Style then
      Result := Word(fwBold);
  end;

  function GetUnderline: TBiffFontUnderline;
  begin
    Result := fuNone;
    if fsUnderline in f.Style then
      Result := fuSingle;
  end;

  function GetFamily: TBiffFontFamily;
  begin
    Result := ffNone;
    if fpFixed = f.Pitch then
      Result := ffModern;
  end;

begin
  Result := 0; // Default font
  if f = nil then Exit;

  font := TBiffFont.Create;
  with font.Data do
  begin
    Height := -MulDiv(f.Height, 1440, f.PixelsPerInch);

    if fsItalic in f.Style then
      AddOption(foItalic);

    if fsStrikeOut in f.Style then
      AddOption(foStruckOut);

    case ss of
      ssSuperscript: Font.Data.Esc := feSuperScript;
      ssSubscript: Font.Data.Esc := feSubScript;
    end;

    Color     := FWorkBook.AddColor(LongWord(f.Color));
    Weight    := GetWeight;
    Underline := GetUnderline;
    Family    := GetFamily;
    Charset   := f.Charset;
  end;

  font.Name := f.Name;
  Result := FWorkBook.AddFont(font);
end;

function TfrxBiffStyles.CreateStyle(s: TfrxIEMStyle; BgPattern, RTL: Boolean): LongInt;

  //
  // Adds a number format for the current cell and
  // returns an index to it.
  //

  function GetFormat: LongInt;
  var
    Fmt, DecSep, ThSep, DecFmt: string;
    p, DecPlaces: Integer;
  begin
    DecSep := '.';
    ThSep := ',';

    Fmt := s.DisplayFormat.FormatStr;

    if Fmt = '' then
    case s.DisplayFormat.Kind of
      fkText:     Result := BiffFmtGeneral;
      fkNumeric:  Result := BiffFmtFixedPoint;
      fkDateTime: Result := BiffFmtDateTime;
      fkBoolean:  Result := BiffFmtGeneral;

      else Result := BiffFmtGeneral
    end
    else if Fmt[1] <> '%' then
      begin
        Fmt := StringReplace(Fmt, '%', '\%', [rfReplaceAll]);
        Result := FWorkBook.AddFormat(Fmt);
      end
    else
    try
      p := Pos('.', Fmt);

      if p = 0 then
        DecPlaces := 0
      else
        DecPlaces := StrToInt(Copy(Fmt, p + 1, Length(Fmt) - p - 1));

      if DecPlaces <> 0 then
        DecFmt := '0' + DecSep + DupChar('0', DecPlaces)
      else
        DecFmt := '0';


      case Fmt[Length(Fmt)] of
        'n': Result := FWorkBook.AddFormat('#' + ThSep + '##' + DecFmt);
        'm'://Guillaume
        begin
          Fmt:='#' + ThSep + '##' + DecFmt;
{$IFDEF DELPHI16}
          case FormatSettings.CurrencyFormat of
            0:Fmt:=FormatSettings.CurrencyString+Fmt; //$1
            1:Fmt:=Fmt+FormatSettings.CurrencyString; //1$
            2:Fmt:=FormatSettings.CurrencyString+' '+Fmt; //$ 1
            3:Fmt:=Fmt+' '+FormatSettings.CurrencyString; //1 $
          end;
{$ELSE}
          case CurrencyFormat of
            0:Fmt:=CurrencyString+Fmt; //$1
            1:Fmt:=Fmt+CurrencyString; //1$
            2:Fmt:=CurrencyString+' '+Fmt; //$ 1
            3:Fmt:=Fmt+' '+CurrencyString; //1 $
          end;
{$ENDIF}

          Result := FWorkBook.AddFormat(Fmt);
        end;
        'f': Result := FWorkBook.AddFormat(DecFmt);
        'd': Result := FWorkBook.AddFormat('#' + DecSep + DupChar('#', DecPlaces));
        'g': Result := BiffFmtGeneral;
        else raise EInvalidFRFormat.Create;
      end;
    except

      //
      // If the format is not "FR-like" then
      // it's assumed to be "Excel-like" and
      // is added to the list of formats.
      //

      Result := FWorkBook.AddFormat(Fmt)
    end;
  end;

  function XFRotation(a: LongInt): Byte;
  begin
    Result := 0;
    if a = 0 then Exit;
    a := a mod 360;
    if a < 0 then Inc(a, 360);
    if a > 180 then Dec(a, 360);

    if (a > 0) and (a <= 90) then
      Result := a;

    if (a < 0) and (a >= -90) then
      Result := -a + 90;
  end;

  { XF cell allows only a few border styles,
    but FastReport's cells allows more kinds
    of cells, so there's not a one-to-one conrrespondence
    between XF border styles and FastReport border styles.

    todo: FR designer allows to specify different borders on
    the left side, the right side and so on, but TfrxIEMStyle
    does not provide access to these properties }

  procedure XFBorder(ft: TfrxFrameType; var b: TBiffLine);
  var
    w:      Single;
    color:  TColor;
    style:  TfrxFrameStyle;

    procedure SWR(ls: TBiffLineStyle; const min, max: Single);
    begin
      if ((min < 0) or (w >= min)) and ((max < 0) or (w <= max)) then
        b.Style := ls;
    end;

  begin
    color := clNone;
    style := fsSolid;
    case ft of
      ftLeft:
        begin
          w := s.LeftLine.Width;
          color := s.LeftLine.Color;
          style := s.LeftLine.Style;
        end;
      ftTop:
        begin
          w := s.TopLine.Width;
          color := s.TopLine.Color;
          style := s.TopLine.Style;
        end;
      ftRight:
        begin
          w := s.RightLine.Width;
          color := s.RightLine.Color;
          style := s.RightLine.Style;
        end;
      ftBottom:
        begin
          w := s.BottomLine.Width;
          color := s.BottomLine.Color;
          style := s.BottomLine.Style;
        end;
    end;

    with FWorkBook do
      b.Color := AddColor(color);

    b.Style := lsNone;
    if w > 1e-6 then
      case style of
        fsSolid:
        begin
          SWR(lsThin, -1, 1.5);
          SWR(lsMedium, 1.5, 2.5);
          SWR(lsThick, 2.5, -1);
        end;

        fsDash:
        begin
          SWR(lsDashed, -1, 1.5);
          SWR(lsMediumDashed, 1.5, -1);
        end;

        fsDot:
          SWR(lsDotted, -1, -1);

        fsDashDot:
        begin
          SWR(lsThinDashDotted, -1, 1.5);
          SWR(lsMediumDashDotted, 1.5, -1);
        end;

        fsDashDotDot:
        begin
          SWR(lsThinDashDotDotted, -1, 1.5);
          SWR(lsMediumDashDotDotted, 1.5, -1);
        end;

        fsDouble: SWR(lsDouble, -1, -1);
        fsAltDot: SWR(lsHair, -1, -1);
        fsSquare: SWR(lsThin, -1, -1);
      end;
  end;

  procedure SetBg(x: TBiffXF; p: TBiffPatternStyle);
  begin
    with x.Data do
      if p = psSolid then
      begin
        Patt        := p;
        PattBgColor := $41;
        PattColor   := FWorkBook.AddColor(LongWord(s.Color));
      end
      else
      begin
        Patt        := p;
        PattBgColor := FWorkBook.AddColor(LongWord(s.Color));
        PattColor   := FWorkBook.AddColor($000000);
      end;
  end;

  function GetIndent(gap: Extended): Byte;
  begin
    Result := 0;
    if gap <= 1.0 then Exit;
    gap := gap / 25.4 * 96 / FTSW;
    Result := Round(gap);
    Result := Result and 7;
  end;

  function GetDirection(RTL: Boolean): TBiffXFTextDir;
  begin
    if RTL then
      Result := xftdRTL
    else
      Result := xftdLTR;
  end;

var
  XF: TBiffXF;
begin
  Result := 15; // Default cell XF
  if s = nil then Exit;

  XF := TBiffXF.Create;
  with XF.Data do
  begin
    Parent := 0; // Must be zero for cell XFs

    if s.Rotation = 90 then
      begin
        case s.HAlign of
          haLeft:   VAlign := xfvaBottom;
          haRight:  VAlign := xfvaTop;
          haCenter: VAlign := xfvaCentered;
          haBlock:  VAlign := xfvaJustified;
        end;

        case s.VAlign of
          vaTop:    HAlign := xfhaLeft;
          vaBottom: HAlign := xfhaRight;
          vaCenter: HAlign := xfhaCentered;
        end;
      end
    else
      if s.Rotation = 270 then
      begin
        case s.HAlign of
          haLeft:   VAlign := xfvaTop;
          haRight:  VAlign := xfvaBottom;
          haCenter: VAlign := xfvaCentered;
          haBlock:  VAlign := xfvaJustified;
        end;

        case s.VAlign of
          vaTop:    HAlign := xfhaRight;
          vaBottom: HAlign := xfhaLeft;
          vaCenter: HAlign := xfhaCentered;
        end;
      end
    else
      begin
        case s.HAlign of
          haLeft:   HAlign := xfhaLeft;
          haRight:  HAlign := xfhaRight;
          haCenter: HAlign := xfhaCentered;
          haBlock:  HAlign := xfhaJustified;
        end;

        case s.VAlign of
          vaTop:    VAlign := xfvaTop;
          vaBottom: VAlign := xfvaBottom;
          vaCenter: VAlign := xfvaCentered;
        end;
      end;

    Direction := GetDirection(RTL);
    WordWrap  := s.WordWrap;
    Rotation  := XFRotation(s.Rotation);

    { todo: suppose that a memo has the right text alignment
      and has a paragraph gap 20 (i.e. not zero). Should there
      be an indent from the right memo border or not ?
      FR designer doesn't make an indent, MS Excel does, but
      I do in the same way as FR designer does. }

    if s.HAlign = haLeft then
      Indent := GetIndent(s.ParagraphGap);

    if ftLeft   in s.FrameTyp then XFBorder(ftLeft, L);
    if ftTop    in s.FrameTyp then XFBorder(ftTop, T);
    if ftRight  in s.FrameTyp then XFBorder(ftRight, R);
    if ftBottom in s.FrameTyp then XFBorder(ftBottom, B);

    if not BgPattern or (s.Color = clNone) then
      SetBg(XF, psNone)
    else
      case s.BrushStyle of
        bsSolid:      SetBg(XF, psSolid);
        bsClear:      SetBg(XF, psSolid);
        bsHorizontal: SetBg(XF, psHor);
        bsVertical:   SetBg(XF, psVer);
        bsBDiagonal:  SetBg(XF, psDiag);
        bsFDiagonal:  SetBg(XF, psDiagBack);
        bsCross:      SetBg(XF, psCross);
        bsDiagCross:  SetBg(XF, psCrossDiag);
      end;

    Format  := GetFormat;
    Font    := CreateFont(s.Font);

    UsedAttrs := BiffXfuaAll;
  end;

  with FWorkBook do
    Result := AddXF(XF);
end;

end.