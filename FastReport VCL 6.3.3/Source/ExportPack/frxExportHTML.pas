
{******************************************}
{                                          }
{             FastReport v6.0              }
{         HTML table export filter         }
{                                          }
{         Copyright (c) 1998-2017          }
{          by Alexander Fediachov,         }
{             Fast Reports Inc.            }
{                                          }
{******************************************}

unit frxExportHTML;

interface

{$I frx.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics,
  frxClass, JPEG, frxExportMatrix, frxProgress,
  Variants, frxExportImage, frxImageConverter, frxExportBaseDialog
{$IFDEF DELPHI16}
, System.UITypes
{$ENDIF}
;

type
  TfrxHTMLExportGetNavTemplate = procedure(const ReportName: String;
    Multipage: Boolean; PicsInSameFolder: Boolean; Prefix: String;
    TotalPages: Integer; var Template: String) of object;

  TfrxHTMLExportGetMainTemplate = procedure(const Title: String;
    const FrameFolder: String;
    Multipage: Boolean; Navigator: Boolean; var Template: String) of object;

  TfrxHTMLExportGetToolbarTemplate = procedure(CurrentPage: Integer; TotalPages: Integer;  Multipage: Boolean; Naviagtor: Boolean; var Template: String) of object;

  TfrxHTMLExportImage = procedure(Image: TGraphic; PicType: TfrxPictureType; var FileName: String) of object;

{$IFDEF DELPHI16}
[ComponentPlatformsAttribute(pidWin32 or pidWin64)]
{$ENDIF}
  TfrxHTMLExport = class(TfrxBaseDialogExportFilter)
  private
    Exp: TStream;
    FAbsLinks: Boolean;
    FCurrentPage: Integer;
    FExportPictures: Boolean;
    FExportStyles: Boolean;
    FFixedWidth: Boolean;
    FMatrix: TfrxIEMatrix;
    FMozillaBrowser: Boolean;
    FMultipage: Boolean;
    FNavigator: Boolean;
    FPicsInSameFolder: Boolean;
    FPicturesCount: Integer;
    FProgress: TfrxProgress;
    FServer: Boolean;
    FPrintLink: String;
    FRefreshLink: String;
    FBackground: Boolean;
    FBackImage: TBitmap;
    FBackImageExist: Boolean;
    FReportPath: String;
    FCentered: Boolean;
    FEmptyLines: Boolean;
    FURLTarget: String;
    FPictureType: TfrxPictureType;

//    FAvExports: String;
//    FSession: String;
    FPrint: Boolean;

    FUseTemplates: Boolean;
    FGetNavTemplate: TfrxHTMLExportGetNavTemplate;
    FGetMainTemplate: TfrxHTMLExportGetMainTemplate;
    FGetToolbarTemplate: TfrxHTMLExportGetToolbarTemplate;
    FExportImage: TfrxHTMLExportImage;

    FHTMLDocumentBegin: TStrings;
    FHTMLDocumentBody: TStrings;
    FHTMLDocumentEnd: TStrings;

    procedure WriteExpLn(const str: String);
    procedure WriteExpLnA(const str: AnsiString);
    procedure ExportPage;
    function ChangeReturns(const Str: String; ParagraphEnd: Boolean = False): String;
    function TruncReturns(const Str: WideString): WideString;
    function GetPicsFolder: String;
    function GetPicsFolderRel: String;
    function GetFrameFolder: String;
    function ReverseSlash(const S: String): String;
    function HTMLCodeStr(const Str: String): String;
  protected
    procedure AfterFinish; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Start: Boolean; override;
    procedure Finish; override;
    procedure FinishPage(Page: TfrxReportPage; Index: Integer); override;
    procedure StartPage(Page: TfrxReportPage; Index: Integer); override;
    procedure ExportObject(Obj: TfrxComponent); override;
    class function GetDescription: String; override;
    class function ExportDialogClass: TfrxBaseExportDialogClass; override;
    property Server: Boolean read FServer write FServer;
    property PrintLink: String read FPrintLink write FPrintLink;
    property RefreshLink: String read FRefreshLink write FRefreshLink;
    property ReportPath: String read FReportPath write FReportPath;

    property UseTemplates: Boolean read FUseTemplates write FUseTemplates;
    property OnGetMainTemplate: TfrxHTMLExportGetMainTemplate read FGetMainTemplate
      write FGetMainTemplate;
    property OnGetToolbarTemplate: TfrxHTMLExportGetToolbarTemplate read FGetToolbarTemplate
      write FGetToolbarTemplate;
    property OnGetNavTemplate: TfrxHTMLExportGetNavTemplate read FGetNavTemplate
      write FGetNavTemplate;
    property OnExportImage: TfrxHTMLExportImage read FExportImage
      write FExportImage;
  published
    property OpenAfterExport;
    property FixedWidth: Boolean read FFixedWidth write FFixedWidth default False;
    property ExportPictures: Boolean read FExportPictures write FExportPictures default True;
    property PicsInSameFolder: Boolean read FPicsInSameFolder write FPicsInSameFolder default False;
    property ExportStyles: Boolean read FExportStyles write FExportStyles default True;
    property Navigator: Boolean read FNavigator write FNavigator default False;
    property Multipage: Boolean read FMultipage write FMultipage default False;
    property MozillaFrames: Boolean read FMozillaBrowser write FMozillaBrowser default False;
    property AbsLinks: Boolean read FAbsLinks write FAbsLinks default False;
    property Background: Boolean read FBackground write FBackground;
    property Centered: Boolean read FCentered write FCentered;
    property EmptyLines: Boolean read FEmptyLines write FEmptyLines;
    property OverwritePrompt;
    property HTMLDocumentBegin: TStrings read FHTMLDocumentBegin;
    property HTMLDocumentBody: TStrings read FHTMLDocumentBody;
    property HTMLDocumentEnd: TStrings read FHTMLDocumentEnd;
    property URLTarget: String read FURLTarget write FURLTarget;
    property Print: Boolean read FPrint write FPrint;
    property PictureType: TfrxPictureType read FPictureType write FPictureType;
  end;


implementation

uses frxUtils, frxFileUtils, frxUnicodeUtils, frxRes, frxrcExports, Math,
  ShellAPI, frxGraphicUtils, frxExportHelpers, frxExportHTMLDialog;

const
  Xdivider = 1;
  Ydivider = 1.03;
  Navigator_src =
    '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">'#13#10 +
    '<html><head>' +
    '<meta http-equiv="Content-Type" content="text/html; charset=utf-8">' +
    '<meta name=Generator content="FastReport 5.0 http://www.fast-report.com">' +
    '<title></title><style type="text/css"><!--'#13#10 +
    'body { font-family: Tahoma; font-size: 8px; font-weight: bold; font-style: normal; text-align: center; vertical-align: middle; }'#13#10 +
    'input {text-align: center}'#13#10 +
    '.nav { font : 9pt Tahoma; color : #283e66; font-weight : bold; text-decoration : none;}'#13#10 +
    '--></style><script language="javascript" type="text/javascript">'#13#10 +
    '  var frCurPage = 1; frPgCnt = %s; var frRepName = "%s"; var frMultipage = %s; var frPrefix="%s";'#13#10 +
    '  function DoPage(PgN) {'#13#10 +
    '    if ((PgN > 0) && (PgN <= frPgCnt) && (PgN != frCurPage)) {'#13#10 +
    '      if (frMultipage > 0)  parent.mainFrame.location = frPrefix + PgN + ".html";'#13#10 +
    '      else parent.mainFrame.location = frPrefix + "main.html#PageN" + PgN;'#13#10 +
    '      UpdateNav(PgN); } else document.PgForm.PgEdit.value = frCurPage; }'#13#10 +
    '  function UpdateNav(PgN) {'#13#10 +
    '    frCurPage = PgN; document.PgForm.PgEdit.value = PgN;'#13#10 +
    '    if (PgN == 1) { document.PgForm.bFirst.disabled = 1; document.PgForm.bPrev.disabled = 1; }'#13#10 +
    '    else { document.PgForm.bFirst.disabled = 0; document.PgForm.bPrev.disabled = 0; }'#13#10 +
    '    if (PgN == frPgCnt) { document.PgForm.bNext.disabled = 1; document.PgForm.bLast.disabled = 1; }'#13#10 +
    '    else { document.PgForm.bNext.disabled = 0; document.PgForm.bLast.disabled = 0; } }'#13#10 +
    '  function RefreshRep() { %s }'#13#10 +
    '  function PrintRep() { %s }'#13#10 +
    '</script></head>'#13#10 +
    '<body bgcolor="#DDDDDD" text="#000000" leftmargin="0" topmargin="4" onload="UpdateNav(frCurPage)">'#13#10 +
    '<form name="PgForm" onsubmit="DoPage(document.forms[0].PgEdit.value); return false;" action="">'#13#10 +
    '<table cellspacing="0" align="left" cellpadding="0" border="0" width="100%%">'#13#10 +
    '<tr valign="middle">'#13#10 +
    '<td width="60" align="center"><button name="bFirst" class="nav" type="button" onclick="DoPage(1); return false;">%s</button></td>'#13#10 +
    '<td width="60" align="center"><button name="bPrev" class="nav" type="button" onclick="DoPage(Math.max(frCurPage - 1, 1)); return false;">%s</button></td>'#13#10 +
    '<td width="100" align="center"><input type="text" class="nav" name="PgEdit" value="frCurPage" size="4"></td>'#13#10 +
    '<td width="60" align="center"><button name="bNext" class="nav" type="button" onclick="DoPage(frCurPage + 1); return false;">%s</button></td>'#13#10 +
    '<td width="60" align="center"><button name="bLast" class="nav" type="button" onclick="DoPage(frPgCnt); return false;">%s</button></td>'#13#10 +
    '<td width="20">&nbsp;</td>'#13#10'%s' +
    '<td align="right">%s: <script language="javascript" type="text/javascript"> document.write(frPgCnt);</script></td>'#13#10 +
    '<td width="10">&nbsp;</td>'#13#10 +
    '</tr></table></form></body></html>';
  Server_sect =
    '<td width="60" align="center"><button name="bRefresh" class="nav" type="button" onclick="RefreshRep(); return false;">%s</button></td>'#13#10 +
    '<td width="60" align="center"><button name="bPrint" class="nav" type="button" onclick="PrintRep(); return false;">%s</button></td>'#13#10;
  DefPrint = 'parent.mainFrame.focus(); parent.mainFrame.print();';
  LinkPrint = 'parent.location = "%s";';
  DefRefresh = 'parent.location = "result?report=" + frRepName + "&multipage=" + frMultipage;';
  LinkRefresh = 'parent.location = "%s";';

{ TfrxHTMLExport }

constructor TfrxHTMLExport.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FExportPictures := True;
  FExportStyles := True;
  FFixedWidth := True;
  FServer := False;
  FPrintLink := '';
  FBackground := False;
  FCentered := False;
  FBackImage := TBitmap.Create;
  FilterDesc := frxGet(8210);
  DefaultExt := frxGet(8211);
  FEmptyLines := True;
  Files := TStringList.Create;
  FUseTemplates := False;
  FHTMLDocumentBegin := TStringList.Create;
  FHTMLDocumentBody := TStringList.Create;
  FHTMLDocumentEnd := TStringList.Create;
  FURLTarget := '';
  FPrint := false;
end;

class function TfrxHTMLExport.GetDescription: String;
begin
  Result := frxResources.Get('HTMLexport');
end;

function TfrxHTMLExport.TruncReturns(const Str: WideString): WideString;
var
  l: Integer;
begin
  l := Length(Str);
  if (l > 1) and (Str[l - 1] = #13) and (Str[l] = #10) then
    Result := Copy(Str, 1, l - 2)
  else
    Result := Str;
end;

procedure TfrxHTMLExport.AfterFinish;
begin
  if OpenAfterExport and (not Assigned(Stream)) then
    if FMultipage and (not FNavigator) then
      ShellExecute(GetDesktopWindow, 'open', PChar(GetPicsFolder + '1.html'),
        nil, nil, SW_SHOW)
    else
      ShellExecute(GetDesktopWindow, 'open', PChar(FileName), nil, nil,
        SW_SHOW);
end;

function TfrxHTMLExport.ChangeReturns(const Str: string; ParagraphEnd: Boolean = False): string;

  function Hex(x: Byte): string;
  const
    d: string = '0123456789abcdef';
  begin
    Result := d[1 + x div 16] + d[1 + x mod 16];
  end;

  function HexColor(x: TColor): string;
  var
    r, g, b: Byte;
  begin
    r := x and 255;
    g := (x shr 8) and 255;
    b := (x shr 16) and 255;

    Result := Hex(r) + Hex(g) + Hex(b);
  end;

  function EscapeSymbols(s: string): string;
  var
    i: Integer;
    c: string;
  begin
    Result := '';

    for i := 1 to Length(s) do
    begin
      c := s[i];

      case s[i] of
        '<': c := '&lt;';
        '>': c := '&gt;';
        '&': c := '&amp;';
        '"': c := '&quot;';
        #13: c := '';
        #10:
          if (i > 1) and (s[i - 1] = #13) then
            c := '<br>';
      end;

      Result := Result + c;
    end;
  end;

  function TaggedStr(s: string; t: TfrxHTMLTag): string;
  begin
    s := EscapeSymbols(s);

    if fsBold in t.Style then
      s := '<b>' + s + '</b>';

    if fsItalic in t.Style then
      s := '<i>' + s + '</i>';

    if fsUnderline in t.Style then
      s := '<u>' + s + '</u>';

    if fsStrikeOut in t.Style then
      s := '<s>' + s + '</s>';

    if t.SubType = ssSubscript then
      s := '<sub>' + s + '</sub>';

    if t.SubType = ssSuperscript then
      s := '<sup>' + s + '</sup>';

    if t.Color <> 0 then
      s := '<span style="color:#' + HexColor(t.Color) + '">' + s + '</span>';

    Result := s;
  end;

var
  i, j: Integer;
  ht: TfrxHTMLTagsList;
  LastTag, Tag: TfrxHTMLTag;
  s: WideString;
begin
  s := Str;

  ht := TfrxHTMLTagsList.Create;
  ht.AllowTags := True;
  ht.ExpandHTMLTags(s);

  LastTag := nil;
  s := '';
  Result := '';

  for i := 0 to ht.Count - 1 do
    for j := 0 to ht[i].Count - 1 do
    begin
      Tag := ht[i][j];

      if (LastTag <> nil) and ((LastTag.Style <> Tag.Style) or (LastTag.Color <> Tag.Color) or (LastTag.SubType <> Tag.SubType)) then
      begin
        Result := Result + TaggedStr(s, LastTag);
        s := '';
      end;

      s := s + Str[Tag.Position + 1];
      LastTag := Tag;
    end;


  if s <> '' then
    Result := Result + TaggedStr(s, LastTag);
  if ParagraphEnd then
    Result := '<p>' + StringReplace(Result, '</br>', '</p><p>', []) + '</p>';

  ht.Free;
end;

procedure TfrxHTMLExport.WriteExpLn(const str: String);
{$IFDEF Delphi12}
var
  TempStr: AnsiString;
{$ENDIF}
begin
{$IFDEF Delphi12}
  TempStr := UTF8Encode(str);
  Exp.Write(TempStr[1], Length(TempStr));
{$ELSE}
  Exp.Write(str[1], Length(str));
{$ENDIF}
  Exp.Write(AnsiChar(#13)+AnsiChar(#10), 2);
end;

procedure TfrxHTMLExport.WriteExpLnA(const str: AnsiString);
begin
  Exp.Write(str[1], Length(str));
  Exp.Write(AnsiChar(#13)+AnsiChar(#10), 2);
end;

procedure TfrxHTMLExport.ExportPage;
var
  i, x, y, dx, dy, fx, fy, pbk: Integer;
  dcol, drow: Integer;
  text, buff: String;
  s, s1, sb, si, su, st, stoolbar: String;
  Vert, Horiz: String;
  obj: TfrxIEMObject;
  EStyle: TfrxIEMStyle;
  hlink, newpage: Boolean;
  tableheader, columnWidths: String;
  imgStream: TStream;

  procedure AlignFR2AlignExcel(HAlign: TfrxHAlign; VAlign: TfrxVAlign;
    var AlignH, AlignV: String);
  begin
    if HAlign = haLeft then
      AlignH := 'Left'
    else if HAlign = haRight then
      AlignH := 'Right'
    else if HAlign = haCenter then
      AlignH := 'Center'
    else if HAlign = haBlock then
      AlignH := 'Justify'
    else
      AlignH := '';
    if VAlign = vaTop then
      AlignV := 'Top'
    else if VAlign = vaBottom then
      AlignV := 'Bottom'
    else if VAlign = vaCenter then
      AlignV := 'Middle'
    else
      AlignV := '';
  end;

  function BorderType( st: TfrxFrameStyle ) : string;
  begin
    case st of
      fsSolid:      Result := 'solid';
      fsDash:       Result := 'dashed';
      fsDot:        Result := 'dotted';
      fsDashDot:    Result := 'dashed';
      fsDashDotDot: Result := 'dotted';
      fsDouble:     Result := 'double';
      fsAltDot:     Result := 'dotted';
      fsSquare:     Result := 'double';
    end;
  end;

  function BorderProp( fl: TfrxFrameLine; pos: String ) : string;
  var
    w: Extended;
  begin
    if fl.Style = fsDouble then
      w := fl.Width*3
    else
      w := fl.Width*1.2;
    if (w > 0) and (w < 1) then w := 1;
    Result :=
    ' border' + pos + 'color:'  + HTMLRGBColor(fl.Color) + ';' +
    ' border' + pos + 'style: ' + BorderType(fl.Style) + ';' +
    ' border' + pos + 'width: ' + IntToStr(Integer(Round(w))) + 'px;';
  end;

begin
  WriteExpLn(FHTMLDocumentBegin.Text);
  if FPrint then
    if FServer then
      WriteExpLn('<script language="javascript" type="text/javascript"> print();</script>')
    else
      WriteExpLn('<script language="javascript" type="text/javascript"> parent.focus(); parent.print();</script>');
  if Length(Report.ReportOptions.Name) > 0 then
    s := Report.ReportOptions.Name
  else
    s := ChangeFileExt(ExtractFileName(frxUnixPath2WinPath(Report.FileName)), '');

  if not FServer then
    WriteExpLnA('<title>' + UTF8Encode(s) + '</title>')
  else if Assigned(FGetToolbarTemplate) then
  begin
    stoolbar := '';
    FGetToolbarTemplate(FCurrentPage, Report.PreviewPages.Count, FMultipage, FNavigator, stoolbar);
    WriteExpLn(stoolbar);
  end;

  if FExportStyles then
  begin
    WriteExpLn('<style type="text/css"><!-- ');
    WriteExpLn('.page_break {page-break-before: always;}');
    for x := 0 to FMatrix.StylesCount - 1 do
    begin
      EStyle := FMatrix.GetStyleById(x);
      s := 's' + IntToStr(x);
      WriteExpLn('.' + s + ' {');
      if Assigned(EStyle.Font) then
      begin
        su := '';
        sb := '';
        si := '';
        if fsBold in EStyle.Font.Style then
          sb := ' font-weight: bold;'
        else
          sb := '';
        if fsItalic in EStyle.Font.Style then
          si := ' font-style: italic;'
        else
          si := ' font-style: normal;';

        if fsUnderline in EStyle.Font.Style then
          su := ' text-decoration: underline';
        if fsStrikeout in EStyle.Font.Style then
        begin
          if su = '' then
            su := ' text-decoration: line-through'
          else
            su := su + ' | line-through';
        end;
        if su <> '' then
          su := su + ';';
        WriteExpLn(' font-family: ' + EStyle.Font.Name + ';'#13#10 +
          ' font-size: ' + IntToStr(Round(EStyle.Font.Size * 96 / 72)) + 'px;'#13#10 +
          ' color: ' + HTMLRGBColor(EStyle.Font.Color) + ';' + sb + si + su);
      end;
      if EStyle.Color = clNone then
        WriteExpLn(' background-color: transparent;')
      else
        WriteExpLn(' background-color: ' + HTMLRGBColor(EStyle.Color) + ';');

      if EStyle.ParagraphGap > 0 then
        WriteExpLn('  text-indent: ' + frxFloatToStr(EStyle.ParagraphGap) + 'px;');

      AlignFR2AlignExcel(EStyle.HAlign, EStyle.VAlign, Horiz, Vert);
      if EStyle.FrameTyp <> [] then
      begin
        if (ftLeft in EStyle.FrameTyp) then
          WriteExpLn(BorderProp(EStyle.LeftLine, '-left-'))
        else
          WriteExpLn(' border-left-width: 0px;');
        if (ftRight in EStyle.FrameTyp) then
          WriteExpLn(BorderProp(EStyle.RightLine, '-right-'))
        else
          WriteExpLn(' border-right-width: 0px;');
        if (ftTop in EStyle.FrameTyp) then
          WriteExpLn(BorderProp(EStyle.TopLine, '-top-'))
        else
          WriteExpLn(' border-top-width: 0px;');
        if (ftBottom in EStyle.FrameTyp) then
          WriteExpLn(BorderProp(EStyle.BottomLine, '-bottom-'))
        else
          WriteExpLn(' border-bottom-width: 0px;');
      end;
      WriteExpLn(' text-align: ' + Horiz + '; vertical-align: ' + Vert +';');
      if EStyle.GapY > 0.5 then
        case EStyle.VAlign of
          vaTop:    WriteExpLn(' padding-top: ' + Format('%dpx;', [Round(EStyle.GapY)]));
          vaBottom: WriteExpLn(' padding-bottom: ' +  Format('%dpx;', [Round(EStyle.GapY)]));
        end;

      if EStyle.GapX > 0.5 then
      begin
        if EStyle.HAlign in [haLeft, haBlock] then
          WriteExpLn(' padding-left: ' + Format('%dpx;', [Round(EStyle.GapX)]));
        if EStyle.HAlign in [haRight, haBlock] then
          WriteExpLn(' padding-right: ' + Format('%dpx;', [Round(EStyle.GapX)]));
      end;
      WriteExpLn('}');
    end;
    WriteExpLn('P {margin: 0;}');
    WriteExpLn('--></style>');
  end;

  if not FServer then
  begin
    WriteExpLn('</head>');
    WriteExpLn('<body');

    if FBackImageExist and FExportPictures then
    begin
      if Assigned(FExportImage) then
      begin
        FExportImage(FBackImage, PictureType, s);
      end
      else
      begin
        s := GetPicsFolder + 'backgrnd.' + GetPicFileExtension(PictureType);
        s1 := ExtractFilePath(s);
        if (s1 = ChangeFileExt(ExtractFileName(frxUnixPath2WinPath(FileName)), '.files' + PathDelim)) or (s1 = '') then
           s := ExtractFilePath(filename) + s;
           imgStream := IOTransport.GetStream(s);
           try
             SaveGraphicAs(FBackImage, imgStream, PictureType);
           finally
             IOTransport.FreeStream(imgStream);
           end;
//        SaveGraphicAs(FBackImage, s, PictureType);
        Files.Add(s);
        s := ReverseSlash(GetPicsFolderRel + 'backgrnd.' + GetPicFileExtension(PictureType));
      end;
      WriteExpLn(' background="' + s + '"');
    end;

    WriteExpLn(' bgcolor="#FFFFFF" text="#000000">');
    WriteExpLn(FHTMLDocumentBody.Text);
  end;

  WriteExpLn('<a name="PageN1"></a>');

  if FFixedWidth then
    st := ' width="' + IntToStr(Round((FMatrix.MaxWidth - FMatrix.Left) / Xdivider)) + '"'
  else
    st := '';

  if FCentered then
    st := st + ' align="center"';

  tableheader := '<table' + st +' border="0" cellspacing="0" cellpadding="0"';
  WriteExpLn(tableheader + '>');

  columnWidths := '<tr style="height: 1px">';
  for x := 0 to FMatrix.Width - 2 do
  begin
    dcol := Round((FMatrix.GetXPosById(x + 1) - FMatrix.GetXPosById(x)) / Xdivider);
    columnWidths := columnWidths + '<td width="' + IntToStr(dcol) + '"/>';
  end;
  if FMatrix.Width < 2 then
    columnWidths := columnWidths + '<td/>';
  columnWidths := columnWidths + '</tr>';
  WriteExpLn(columnWidths);

  pbk := 0;
  st := '';
  newpage := False;

  for y := 0 to FMatrix.Height - 2 do
  begin
    if ShowProgress and (not FMultipage) then
      if FProgress.Terminated then
        break;
    drow := Round((FMatrix.GetYPosById(y + 1) - FMatrix.GetYPosById(y)) / Ydivider);
    s := '';
    if FMatrix.PagesCount > pbk then
      if Round(FMatrix.GetPageBreak(pbk)) <= Round(FMatrix.GetYPosById(y + 1)) then
      begin
        Inc(pbk);
        if ShowProgress and (not FMultipage) then
          FProgress.Tick;
        newpage := True;
      end;
    if drow = 0 then
      drow := 1;
    WriteExpLn('<tr style="height:' + IntToStr(drow) + 'px">');
    buff := '';
    for x := 0 to FMatrix.Width - 2 do
    begin
      if ShowProgress and (not FMultipage) then
        if FProgress.Terminated then
          break;
      i := FMatrix.GetCell(x, y);
      if (i <> -1) then
      begin
        Obj := FMatrix.GetObjectById(i);
        if Obj.Counter = 0 then
        begin
          FMatrix.GetObjectPos(i, fx, fy, dx, dy);
          Obj.Counter := 1;

          if dx > 1 then
            s := ' colspan="' + IntToStr(dx) + '"'
          else
            s := '';
          if dy > 1 then
            sb := ' rowspan="' + IntToStr(dy) + '"'
          else
            sb := '';
          if FExportStyles then
            st := ' class="' + 's' + IntToStr(Obj.StyleIndex) + '"'
          else
            st := '';
          if Length(Trim(Obj.Memo.Text)) = 0 then
            st := st + ' style="font-size:1px"';

          buff := buff + '<td' + s + sb + st + '>';

          if Length(Obj.URL) > 0 then
          begin
            if Obj.URL[1] = '@' then
              if  FMultipage then
              begin
                Obj.URL := StringReplace(Obj.URL, '@', '', []);
                Obj.URL := ReverseSlash(GetPicsFolderRel + Trim(Obj.URL) + '.html')
              end
              else
                Obj.URL := StringReplace(Obj.URL, '@', '#PageN', []);
            if FURLTarget <> '' then
              s := ' target=' + FURLTarget
            else
              s := '';
            buff := buff + '<a href="' + Obj.URL + '"' + s + '>';
            hlink := True;
          end
          else
            hlink := False;

          if Obj.IsText then
          begin
{$IFDEF Delphi12}
            text := ChangeReturns(TruncReturns(Obj.Memo.Text), (Obj.Style.ParagraphGap <> 0) and (Obj.Memo.Count > 1));
{$ELSE}
            text := ChangeReturns(UTF8Encode(TruncReturns(Obj.Memo.Text)), (Obj.Style.ParagraphGap <> 0) and (Obj.Memo.Count > 1));
{$ENDIF}
            if Length(text) > 0 then
              buff := buff + text
            else
              buff := buff + '&nbsp;';
          end else
          if Obj.Image <> nil then
          begin
            if Assigned(FExportImage) then
            begin
              FExportImage(Obj.Image, PictureType, s);
            end
            else
            begin
              s := GetPicsFolder + 'img' + IntToStr(FPicturesCount) + '.' + GetPicFileExtension(PictureType);
              s1 := ExtractFilePath(s);
              if (s1 = ChangeFileExt(ExtractFileName(frxUnixPath2WinPath(FileName)), '.files' + PathDelim)) or (s1 = '') then
                s := ExtractFilePath(filename) + s;
//              SaveGraphicAs(Obj.Image, s, PictureType);
              imgStream := IOTransport.GetStream(s);
              try
                SaveGraphicAs(Obj.Image, imgStream, PictureType);
              finally
                IOTransport.FreeStream(imgStream);
              end;

              Files.Add(s);
              if FServer then
                s := ExtractFileName(ExtractFileDir(s)) + PathDelim
              else
                s := '';
              s := ReverseSlash( s + GetPicsFolderRel + 'img' + IntToStr(FPicturesCount) + '.' + GetPicFileExtension(PictureType));
            end;
            buff := buff + Format('<img src="%s" width="%d" height="%d" alt="">',
              [UTF8Encode(s), Obj.Image.Width, Obj.Image.Height]);

            Inc(FPicturesCount);

          end;
          if hlink then
            buff := buff + '</a>';
          buff := buff + '</td>';
        end;
      end
      else
        buff := buff + '<td/>';
    end;
    WriteExpLn(buff);
    WriteExpLn('</tr>');
    if newpage then
    begin
      WriteExpLn('</table>');
      newpage := False;
      if y < FMatrix.Height - 2 then
      begin
        WriteExpLn('<a name="PageN' + IntToStr(pbk + 1) + '"></a>');
        WriteExpLn(tableheader + ' class="page_break">');
        WriteExpLn(columnWidths);
      end;
    end;
  end;
  if FMultipage or (FMatrix.Height < 2) then
    WriteExpLn('</table>');
  WriteExpLn(FHTMLDocumentEnd.Text);
end;

function TfrxHTMLExport.Start: Boolean;
begin
  HTMLDocumentBegin.Clear;
  HTMLDocumentEnd.Clear;

  if not FServer then
  begin
    FHTMLDocumentBegin.Add('<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">');
    FHTMLDocumentBegin.Add('<html><head>');
    FHTMLDocumentBegin.Add('<meta http-equiv="Content-Type" content="text/html; charset=utf-8">');
    FHTMLDocumentBegin.Add('<meta name=Generator content="FastReport 5.0 http://www.fast-report.com">');
    FHTMLDocumentEnd.Add('</body></html>');
  end;

  FPicsInSameFolder := FPicsInSameFolder or IOTransport.AllInOneContainer;

  if SlaveExport and (FileName = '') then
  begin
    OpenAfterExport := False;
    FExportPictures := True;
    FPicsInSameFolder := True;
    FNavigator := False;
    FMultipage := False;
    FBackground := False;
  end;
  if (FileName <> '') or Assigned(Stream) then
  begin
    FCurrentPage := 0;
    FPicturesCount := 0;
    FMatrix := TfrxIEMatrix.Create(UseFileCache, Report.EngineOptions.TempDir);
    FMatrix.Report := Report;
    if not FMultipage then
      FMatrix.ShowProgress := ShowProgress
    else
      FMatrix.ShowProgress := False;
    FMatrix.Inaccuracy := 0.5;
    FMatrix.RotatedAsImage := True;
    FMatrix.FramesOptimization := True;
    FMatrix.Background := FBackground;
    FMatrix.BackgroundImage := False;
    FMatrix.Printable := ExportNotPrintable;
    FMatrix.RichText := True;
    FMatrix.PlainRich := True;
    FMatrix.EmptyLines := EmptyLines;
    if Assigned(Stream) then
    begin
      FMultipage := False;
      FExportPictures := False;
      FNavigator := False;
    end;
    Result := True
  end
  else
    Result := False;
  Files.Clear;
end;

procedure TfrxHTMLExport.StartPage(Page: TfrxReportPage; Index: Integer);
begin
  Inc(FCurrentPage);
  FBackImageExist := False;
  FBackImage.Width := 0;
  FBackImage.Height := 0;
end;

class function TfrxHTMLExport.ExportDialogClass: TfrxBaseExportDialogClass;
begin
  Result := TfrxHTMLExportDialog;
end;

procedure TfrxHTMLExport.ExportObject(Obj: TfrxComponent);
var v: TfrxView;
begin
  if Obj is TfrxView then
  begin
    v := Obj as TfrxView;
    if vsExport in v.Visibility then
      begin
        if (v is TfrxCustomMemoView) or (v is TfrxLineView) or
           (FExportPictures and (not (v is TfrxCustomMemoView))) then
          FMatrix.AddObject(v);
        if (v.Name = '_pagebackground') and FExportPictures and FBackground then
        begin
          FBackImageExist := True;
          FBackImage.Canvas.Lock;
          try
            FBackImage.Width := Round(v.Width);
            FBackImage.Height := Round(v.Height);
            v.Draw(FBackImage.Canvas ,1, 1, -v.AbsLeft, -v.AbsTop);
          finally
            FBackImage.Canvas.Unlock;
          end;
        end;
      end;
  end;
end;

procedure TfrxHTMLExport.FinishPage(Page: TfrxReportPage; Index: Integer);
var
  s: String;
begin
  if FMultipage then
  begin
    FMatrix.Prepare;
    try
      s := GetPicsFolder + IntToStr(FCurrentPage) + '.html';
      Files.Add(s);
      Exp := IOTransport.GetStream(s);
//      Exp := TFileStream.Create(s, fmCreate);
      try
        ExportPage;
      finally
        FMatrix.Clear;
        IOTransport.FreeStream(Exp);
//        Exp.Free;
      end;
    except
      on e: Exception do
        case Report.EngineOptions.NewSilentMode of
          simSilent:        Report.Errors.Add(e.Message);
          simMessageBoxes:  frxErrorMsg(e.Message);
          simReThrow:       raise;
        end;
    end;
  end
  else FMatrix.AddPage(Page.Orientation, Page.Width, Page.Height, Page.LeftMargin,
                    Page.TopMargin, Page.RightMargin, Page.BottomMargin, Page.MirrorMargins, Index);
end;

procedure TfrxHTMLExport.Finish;
var
  s, st, print: String;
  serv, Refresh: String;
{$IFDEF Delphi12}
  TempString: AnsiString;
{$ENDIF}
begin
  if not FMultipage then
  begin
    if ShowProgress then
    begin
      FProgress := TfrxProgress.Create(nil);
      FProgress.Execute(FCurrentPage - 1, frxResources.Get('ProgressWait'), true, true);
    end;
    FMatrix.Prepare;
    try
      if ShowProgress then
        if FProgress.Terminated then
          Exit;
      if not Assigned(Stream) then
      begin
        if FNavigator then
        begin
          s := GetPicsFolder + 'main.html';
          Files.Add(s);
          //Exp := TFileStream.Create(s, fmCreate);
          Exp := IOTransport.GetStream(s);
        end
        else
        begin
          //Exp := TFileStream.Create(FileName, fmCreate);
          Exp := IOTransport.GetStream(FileName);
          Files.Add(FileName);
        end;
      end
      else
        Exp := Stream;
      try
        ExportPage;
      finally
        FMatrix.Clear;
        if not Assigned(Stream) then
//          Exp.Free;
          IOTransport.FreeStream(Exp);
      end;
    except
      on e: Exception do
        case Report.EngineOptions.NewSilentMode of
          simSilent:        Report.Errors.Add(e.Message);
          simMessageBoxes:  frxErrorMsg(e.Message);
          simReThrow:       raise;
        end;
    end;
    if ShowProgress then
      FProgress.Free;
  end;
  if FNavigator then
  begin
    if not FServer then
    begin
      try
        s := GetPicsFolder + 'nav.html';
        Files.Add(s);
        //Exp := TFileStream.Create(s, fmCreate);
        Exp := IOTransport.GetStream(s);
        try
          if not FUseTemplates then
          begin
            if FMultipage then
              s := '1'
            else
              s := '0';
            st := '';
            if FPicsInSameFolder then
              st := ChangeFileExt(ExtractFileName(frxUnixPath2WinPath(FileName)), '.');
//            if FServer then
//              serv := Format(Server_sect, [UTF8Encode(frxResources.Get('HTMLNavRefresh')), UTF8Encode(frxResources.Get('HTMLNavPrint'))])
//            else
              serv := '';
            if Length(FPrintLink) > 0 then
              print := Format(LinkPrint, [FPrintLink])
            else
              print := DefPrint;

            if Length(FRefreshLink) > 0 then
              refresh := Format(LinkRefresh, [FRefreshLink])
            else
              refresh := DefRefresh;

            WriteExpLn(Format(Navigator_src, [
              IntToStr(FCurrentPage),
              HTMLCodeStr(StringReplace(Report.FileName, FReportPath, '', [])),
              s, st, Refresh, print,
              UTF8Encode(frxResources.Get('HTMLNavFirst')),
              UTF8Encode(frxResources.Get('HTMLNavPrev')),
              UTF8Encode(frxResources.Get('HTMLNavNext')),
              UTF8Encode(frxResources.Get('HTMLNavLast')),
              serv, UTF8Encode(frxResources.Get('HTMLNavTotal'))]));
          end
          else
          begin
            if Assigned(FGetNavTemplate) then
            begin
              s := '';
              FGetNavTemplate(HTMLCodeStr(StringReplace(Report.FileName, FReportPath, '', [])),
                FMultipage, FPicsInSameFolder,
                ChangeFileExt(ExtractFileName(frxUnixPath2WinPath(FileName)), '.'),
                FCurrentPage,
                s
              );
              {$IFDEF Delphi12}
              TempString := UTF8Encode(s);
              Exp.Write(TempString[1], Length(TempString));
              {$ELSE}
              Exp.Write(s[1], Length(s));
              {$ENDIF}
            end;
          end;
        finally
          //Exp.Free;
          IOTransport.FreeStream(Exp);
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

    try
      Files.Add(FileName);
      //Exp := TFileStream.Create(FileName, fmCreate);
      Exp := IOTransport.GetStream(FileName);
      try
        if Length(Report.ReportOptions.Name) > 0 then
          s := Report.ReportOptions.Name
        else
          s := ChangeFileExt(ExtractFileName(frxUnixPath2WinPath(Report.FileName)), '');
        if not FUseTemplates then
        begin
          WriteExpLn('<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">');
          WriteExpLn('<html><head>');
          WriteExpLnA('<title>' + UTF8Encode(s) + '</title>');
          WriteExpLn('<meta http-equiv="Content-Type" content="text/html; charset=utf-8">');
          WriteExpLn('<script language="javascript" type="text/javascript"> </script></head>');
          WriteExpLn('<frameset rows="32,*" cols="*">');
          WriteExpLn('<frame name="topFrame" src="' + ReverseSlash(GetFrameFolder) + 'nav.html" noresize scrolling="no">');
          if FMultipage then
            WriteExpLn('<frame name="mainFrame" src="' + ReverseSlash(GetFrameFolder) + '1.html">')
          else
            WriteExpLn('<frame name="mainFrame" src="' + ReverseSlash(GetFrameFolder) + 'main.html">');
          WriteExpLn('</frameset>');
          WriteExpLn('</html>');
        end
        else
        begin
          if Assigned(FGetMainTemplate) then
          begin
            st := '';
            FGetMainTemplate(
              String(UTF8Encode(s)), // title
              ReverseSlash(GetFrameFolder), // frame folder
              FMultipage,  // multipage
              FNavigator,
              st
            );
            {$IFDEF Delphi12}
            TempString := UTF8Encode(st);
            Exp.Write(TempString[1], Length(TempString));
            {$ELSE}
            Exp.Write(st[1], Length(st));
            {$ENDIF}
          end;
        end;
      finally
        IOTransport.FreeStream(Exp);
        //Exp.Free;
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

  FMatrix.Free;
end;

function TfrxHTMLExport.GetPicsFolderRel: String;
begin
  if FPicsInSameFolder then
    Result := ChangeFileExt(ExtractFileName(frxUnixPath2WinPath(FileName)), '.')
  else if FMultipage then
    Result := ''
  else if FAbsLinks then
    Result := ExtractFilePath(FileName) +
      ChangeFileExt(ExtractFileName(frxUnixPath2WinPath(FileName)),'.files')
      + PathDelim
  else if FNavigator then
    Result := ''
  else
    Result := ChangeFileExt(ExtractFileName(frxUnixPath2WinPath(FileName)),'.files')
      + PathDelim
end;

function TfrxHTMLExport.GetFrameFolder: String;
begin
  if not FPicsInSameFolder then
    Result := ChangeFileExt(ExtractFileName(frxUnixPath2WinPath(FileName)),'.files')
     + PathDelim
  else
    Result := ChangeFileExt(ExtractFileName(frxUnixPath2WinPath(FileName)), '.');
end;

function TfrxHTMLExport.GetPicsFolder: String;
//var
//  SecAtrtrs: TSecurityAttributes;
begin
  if FPicsInSameFolder then
  begin
    if FAbsLinks then
      Result := ExtractFilePath(FileName) + ChangeFileExt(ExtractFileName(frxUnixPath2WinPath(FileName)), '.')
    else
      Result := ChangeFileExt(frxUnixPath2WinPath(FileName), '.')
  end
  else
  begin
    if FAbsLinks then
      Result := ExtractFilePath(FileName) + ChangeFileExt(ExtractFileName(frxUnixPath2WinPath(FileName)), '.files')
    else
      Result := ChangeFileExt(frxUnixPath2WinPath(FileName), '.files');
//    SecAtrtrs.nLength := SizeOf(TSecurityAttributes);
//    SecAtrtrs.lpSecurityDescriptor := nil;
//    SecAtrtrs.bInheritHandle := True;
//    CreateDirectory(PChar(Result), @SecAtrtrs);
    Result := Result +  PathDelim;
  end;
end;

function TfrxHTMLExport.ReverseSlash(const S: String): String;
begin
  Result := StringReplace(S, '\', '/', [rfReplaceAll]);
end;

destructor TfrxHTMLExport.Destroy;
begin
  FHTMLDocumentBegin.Free;
  FHTMLDocumentBody.Free;
  FHTMLDocumentEnd.Free;
  FBackImage.Free;
  Files.Free;
  Files := nil;
  inherited;
end;

function TfrxHTMLExport.HTMLCodeStr(const Str: String): String;
var
  i: Integer;
  c: Char;
  s: String;

  function StrToHex(const s: String): String;
  var
    Len, i: Integer;
    C, H, L: Byte;

    function HexChar(N : Byte) : Char;
    begin
      if (N < 10) then Result := Chr(Ord('0') + N)
      else Result := Chr(Ord('A') + (N - 10));
    end;

  begin
    Len := Length(s);
    SetLength(Result, Len shl 1);
    for i := 1 to Len do begin
      C := Ord(s[i]);
      H := (C shr 4) and $f;
      L := C and $f;
      Result[i shl 1 - 1] := HexChar(H);
      Result[i shl 1]:= HexChar(L);
    end;
  end;

begin
  Result := '';
  for i := 1 to Length(Str) do
  begin
    c := Str[i];
    case c of
     '0'..'9', 'A'..'Z', 'a'..'z': Result := Result + c;
      else begin
        s := c;
        Result := Result + '%' + StrToHex(s);
      end
   end;
  end;
end;

end.
