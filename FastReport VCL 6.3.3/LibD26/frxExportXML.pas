
{******************************************}
{                                          }
{             FastReport v6.0              }
{            XML Excel export              }
{                                          }
{         Copyright (c) 1998-2017          }
{          by Alexander Fediachov,         }
{             Fast Reports Inc.            }
{                                          }
{******************************************}
{        Improved by Bysoev Alexander      }
{             Kanal-B@Yandex.ru            }
{******************************************}

unit frxExportXML;

interface

{$I frx.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics,
  Printers, ComObj, frxClass, frxExportMatrix, frxProgress,
  frxExportBaseDialog, Variants
{$IFDEF DELPHI16}
, System.UITypes
{$ENDIF}
;

type
  TfrxSplitToSheet = (ssNotSplit, ssRPages, ssPrintOnPrev, ssRowsCount);

{$IFDEF DELPHI16}
[ComponentPlatformsAttribute(pidWin32 or pidWin64)]
{$ENDIF}
  TfrxXMLExport = class(TfrxBaseDialogExportFilter)
  private
    FExportPageBreaks: Boolean;
    FExportStyles: Boolean;
    FFirstPage: Boolean;
    FMatrix: TfrxIEMatrix;
    FPageBottom: Extended;
    FPageLeft: Extended;
    FPageRight: Extended;
    FPageTop: Extended;
    FPageOrientation: TPrinterOrientation;
    FPaperNames: TStringList;
    FPaperSizes: array of integer;
    FPaperOrientations: array of TPrinterOrientation;
    FProgress: TfrxProgress;
    FWysiwyg: Boolean;
    FBackground: Boolean;
    FCreator: String;
    FEmptyLines: Boolean;
    FRowsCount: Integer;
    FSplit: TfrxSplitToSheet;

    procedure ExportPage(Stream: TStream);
    function ChangeReturns(const Str: String): String;
    function TruncReturns(const Str: WideString): WideString;
    procedure SetRowsCount(const Value: Integer);
    function GetOpenExcel: Boolean;
    procedure SetOpenExcel(const Value: Boolean);
  public
    constructor Create(AOwner: TComponent); override;
    class function GetDescription: String; override;
    class function ExportDialogClass: TfrxBaseExportDialogClass; override;
    function Start: Boolean; override;
    procedure Finish; override;
    procedure FinishPage(Page: TfrxReportPage; Index: Integer); override;
    procedure StartPage(Page: TfrxReportPage; Index: Integer); override;
    procedure ExportObject(Obj: TfrxComponent); override;
  published
    property ExportStyles: Boolean read FExportStyles write FExportStyles default True;
    property ExportPageBreaks: Boolean read FExportPageBreaks write FExportPageBreaks default True;
    property OpenExcelAfterExport: Boolean read GetOpenExcel
      write SetOpenExcel default False; // back comp
    property Wysiwyg: Boolean read FWysiwyg write FWysiwyg default True;
    property Background: Boolean read FBackground write FBackground default False;
    property Creator: string read FCreator write FCreator;
    property EmptyLines: Boolean read FEmptyLines write FEmptyLines;
    property SuppressPageHeadersFooters;
    property OverwritePrompt;
    property RowsCount: Integer read FRowsCount write SetRowsCount;
    property Split: TfrxSplitToSheet read FSplit write FSplit;
  end;


implementation

uses frxUtils, frxFileUtils, frxUnicodeUtils, frxRes, frxrcExports, frxStorage, frxExportXMLDialog;


const
  Xdivider = 1.6;
  Ydivider = 1.376;
  MargDiv = 26.6;
  XLMaxHeight = 409;


{ TfrxXMLExport }

constructor TfrxXMLExport.Create(AOwner: TComponent);
begin
  inherited;
  FExportPageBreaks := True;
  FExportStyles := True;
  FWysiwyg := True;
  FBackground := True;
  FCreator := 'FastReport';
  FilterDesc := frxGet(8105);
  DefaultExt := frxGet(8106);
  FEmptyLines := True;
end;

class function TfrxXMLExport.GetDescription: String;
begin
  Result := frxResources.Get('XlsXMLexport');
end;

function TfrxXMLExport.GetOpenExcel: Boolean;
begin
  Result := OpenAfterExport;
end;

function TfrxXMLExport.TruncReturns(const Str: WideString): WideString;
var
  l: Integer;
begin
  l := Length(Str);
  if (l > 1) and (Str[l - 1] = #13) and (Str[l] = #10) then
    Result := Copy(Str, 1, l - 2)
  else
    Result := Str;
end;

function TfrxXMLExport.ChangeReturns(const Str: string): string;
var
  i: Integer;
begin
  Result := '';

  for i := 1 to Length(Str) do
  case Str[i] of
    '&': Result := Result + '&amp;';
    '"': Result := Result + '&quot;';
    '<': Result := Result + '&lt;';
    '>': Result := Result + '&gt;';
    #13: {skip this symbol};
    #0..#12, #14..#31: Result := Result + '&#' + IntToStr(Ord(Str[i])) + ';';
    else Result := Result + Str[i]
  end
end;

procedure TfrxXMLExport.ExportPage(Stream: TStream);
var
  i, x, y, dx, dy, fx, fy, Page, LastPrevRow: Integer;
  {$IFDEF Delphi12}
  s: WideString;
  {$ELSE}
  s: string;
  {$ENDIF}
  sb, si, su, ss, decsep, thsep: String;
  dcol, drow: Extended;
  Vert, Horiz: String;
  obj: TfrxIEMObject;
  IEMPage: TfrxIEMPage;
  EStyle: TfrxIEMStyle;
  St, PrevPageName: String;
  PageBreak: TStringList;

  function IsDigits(const Str: String): Boolean;
  var
    i: Integer;
  begin
    Result := True;
    for i := 1 to Length(Str) do
      if not((AnsiChar(Str[i]) in ['0'..'9', ',' ,'.' ,'-', '+', ' ', 'ð', 'e', 'E']) or (Ord(Str[i]) = 160)) then
      begin
        Result := False;
        break;
      end;
  end;

  procedure WriteExpLn(const str: String);
{$IFDEF Delphi12}
  var
    TempStr: AnsiString;
{$ENDIF}
  begin
{$IFDEF Delphi12}
    TempStr := UTF8Encode(str);
    if Length(TempStr) > 0 then
      Stream.Write(TempStr[1], Length(TempStr));
    Stream.Write(AnsiString(#13#10), 2);
{$ELSE}
    if Length(str) > 0 then
      Stream.Write(str[1], Length(str));
    Stream.Write(#13#10, 2);
{$ENDIF}
  end;

  procedure AlignFR2AlignExcel(HAlign: TfrxHAlign; VAlign: TfrxVAlign;
    var AlignH, AlignV: String; Rotation: integer);
  begin
    if Rotation = 90 then
      begin
        if HAlign = haLeft then
          AlignV := 'Bottom'
        else if HAlign = haRight then
          AlignV := 'Top'
        else if HAlign = haCenter then
          AlignV := 'Center'
        else if HAlign = haBlock then
          AlignV := 'Justify'
        else
          AlignV := '';

        if VAlign = vaTop then
          AlignH := 'Left'
        else if VAlign = vaBottom then
          AlignH := 'Right'
        else if VAlign = vaCenter then
          AlignH := 'Center'
        else
          AlignV := '';
      end
    else if Rotation = 270 then
      begin
        if HAlign = haLeft then
          AlignV := 'Top'
        else if HAlign = haRight then
          AlignV := 'Bottom'
        else if HAlign = haCenter then
          AlignV := 'Center'
        else if HAlign = haBlock then
          AlignV := 'Justify'
        else
          AlignV := '';

        if VAlign = vaTop then
          AlignH := 'Right'
        else if VAlign = vaBottom then
          AlignH := 'Left'
        else if VAlign = vaCenter then
          AlignH := 'Center'
        else
          AlignV := '';
      end
    else
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
          AlignV := 'Center'
        else
          AlignV := '';
      end;
  end;

  function ConvertFormat(const fstr, fdecsep, fthsep: string): string;
  var
    err, p : integer;
    s: string;
  begin
    result := '';
    s := '';
    if length(fstr)>0 then
    begin
      p := pos('.', fstr);
      if p > 0 then
      begin
        s := Copy(fstr, p+1, length(fstr)-p-1);
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
      case fstr[length(fstr)] of
        'n': result := '#,##0' + s;
        'f': result := '0' + s;
        'g': result := '0.##';
        'm': result := '#,##0.00';
//        'm': result := '#,##0.00&quotð.;&quot;';
      else
        if (pos('E', fstr) <> 0) or (pos('e', fstr) <> 0) then
          result := fstr
        else
          result := '#,##0.00';
      end;
    end;
  end;

  procedure FinishWorkSheet;
  var
    i: Integer;
  begin
    WriteExpLn('</Table>');
    WriteExpLn('<WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">');
    WriteExpLn('<PageSetup>');
    if (((FSplit = ssRPages) or (FSPlit = ssPrintOnPrev)) and (FPaperNames.IndexOf(PrevPageName) <> -1)) or
        ((FSplit in [ssNotSplit, ssRowsCount]) and (FPaperNames.Count = 1)) then
      begin
        if FPaperNames.Count = 1 then
          begin
            if FPaperOrientations[0] = poLandscape then WriteExpLn('<Layout x:Orientation="Landscape"/>');
          end
        else
          begin
            if FPaperOrientations[FPaperNames.IndexOf(PrevPageName)] = poLandscape then WriteExpLn('<Layout x:Orientation="Landscape"/>');
          end;
      end
    else if FPageOrientation = poLandscape then
      WriteExpLn('<Layout x:Orientation="Landscape"/>');
    WriteExpLn('<PageMargins x:Bottom="' + frFloat2Str(FPageBottom / MargDiv, 2) +
      '" x:Left="' + frFloat2Str(FPageLeft / MargDiv, 2) +
      '" x:Right="' + frFloat2Str(FPageRight / MargDiv, 2) +
      '" x:Top="' + frFloat2Str(FPageTop / MargDiv, 2) + '"/>');
    WriteExpLn('</PageSetup>');
    if (((FSplit = ssRPages) or (FSPlit = ssPrintOnPrev)) and (FPaperNames.IndexOf(PrevPageName) <> -1)) or
        ((FSplit in [ssNotSplit, ssRowsCount]) and (FPaperNames.Count = 1)) then
      begin
        WriteExpLn('<Print>');
        WriteExpLn('<ValidPrinterInfo/>');
        if FPaperNames.Count = 1 then
          WriteExpLn('<PaperSizeIndex>' + IntToStr(FPaperSizes[0]) +'</PaperSizeIndex>')
        else
          WriteExpLn('<PaperSizeIndex>' + IntToStr(FPaperSizes[FPaperNames.IndexOf(PrevPageName)]) +'</PaperSizeIndex>');
        WriteExpLn('</Print>');
      end;
    WriteExpLn('</WorksheetOptions>');

    if FExportPageBreaks then
    begin
      WriteExpLn('<PageBreaks xmlns="urn:schemas-microsoft-com:office:excel">');
      WriteExpLn('<RowBreaks>');
      for i := 0 to PageBreak.Count - 1 do
      begin
        WriteExpLn('<RowBreak>');
        WriteExpLn('<Row>' + PageBreak[i] + '</Row>');
        WriteExpLn('</RowBreak>');
      end;
      WriteExpLn('</RowBreaks>');
      WriteExpLn('</PageBreaks>');
    end;
    if PageBreak.Count > 0 then
      LastPrevRow := LastPrevRow + StrToInt(PageBreak[PageBreak.Count - 1]);
    PageBreak.Clear;
    WriteExpLn('</Worksheet>');
  end;

  procedure StartWorkSheet(SheetName: String);
  var
    x:Integer;
  begin
    if SheetName = '' then SheetName := 'UnnamedPage_' + IntTostr(Page);
{$IFDEF Delphi12}
    WriteExpLn('<Worksheet ss:Name="' + SheetName + '">');
{$ELSE}
    WriteExpLn('<Worksheet ss:Name="' + UTF8Encode(SheetName) + '">');
{$ENDIF}

    WriteExpLn('<Table ss:ExpandedColumnCount="' + IntToStr(FMatrix.Width) + '"' +
      ' ss:ExpandedRowCount="' + IntToStr(FMatrix.Height) + '" x:FullColumns="1" x:FullRows="1">');

    for x := 1 to FMatrix.Width - 1 do
    begin
      dcol := (FMatrix.GetXPosById(x) - FMatrix.GetXPosById(x - 1)) / Xdivider;
      WriteExpLn('<Column ss:AutoFitWidth="0" ss:Width="' +
        frFloat2Str(dcol, 2) + '"/>');
    end;
  end;

  function BorderProp(fl: TfrxFrameLine): string;
  var
    sis: string;
  begin
    if fl.Width > 1 then i := 3 else i := 1;

    case fl.Style of
      fsSolid:      sis := 'Continuous';
      fsDash:       sis := 'Dash';
      fsDot:        sis := 'Dot';
      fsDashDot:    sis := 'Dot';
      fsDashDotDot: sis := 'Dot';
      fsDouble:     sis := 'Double';
      fsAltDot:     sis := 'Dot';
      fsSquare:     sis := 'Double';
    end;

    s := 'ss:Weight="' + IntToStr(i) + '" ';
    si := 'ss:Color="' + HTMLRGBColor(fl.Color) + '" ';
    Result := ' ss:LineStyle="' + sis + '" ' + s + si;
  end;

begin
  PageBreak := TStringList.Create;

  try
    if ShowProgress then
    begin
      FProgress := TfrxProgress.Create(nil);
      FProgress.Execute(FMatrix.PagesCount, 'Exporting pages', True, True);
    end;

    WriteExpLn('<?xml version="1.0"?>');
    WriteExpLn('<?mso-application progid="Excel.Sheet"?>');
{$IFDEF Delphi12}
    WriteExpLn('<?fr-application created="' + FCreator + '"?>');
{$ELSE}
    WriteExpLn('<?fr-application created="' + UTF8Encode(FCreator) + '"?>');
{$ENDIF}
    WriteExpLn('<?fr-application homesite="http://www.fast-report.com"?>');
    WriteExpLn('<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet"');
    WriteExpLn(' xmlns:o="urn:schemas-microsoft-com:office:office"');
    WriteExpLn(' xmlns:x="urn:schemas-microsoft-com:office:excel"');
    WriteExpLn(' xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"');
    WriteExpLn(' xmlns:html="http://www.w3.org/TR/REC-html40">');
    WriteExpLn('<DocumentProperties xmlns="urn:schemas-microsoft-com:office:office">');
{$IFDEF Delphi12}
    WriteExpLn('<Title>' + Report.ReportOptions.Name + '</Title>');
    WriteExpLn('<Author>' + Report.ReportOptions.Author + '</Author>');
{$ELSE}
    WriteExpLn('<Title>' + UTF8Encode(Report.ReportOptions.Name) + '</Title>');
    WriteExpLn('<Author>' + UTF8Encode(Report.ReportOptions.Author) + '</Author>');
{$ENDIF}
//    WriteExpLn('<Created>' + DateToStr(CreationTime) + 'T' + TimeToStr(CreationTime) + 'Z</Created>');
{$IFDEF Delphi12}
    WriteExpLn('<Version>' + Report.ReportOptions.VersionMajor + '.' +
      Report.ReportOptions.VersionMinor + '.' +
      Report.ReportOptions.VersionRelease + '.' +
      Report.ReportOptions.VersionBuild + '</Version>');
{$ELSE}
    WriteExpLn('<Version>' + UTF8Encode(Report.ReportOptions.VersionMajor) + '.' +
      UTF8Encode(Report.ReportOptions.VersionMinor) + '.' +
      UTF8Encode(Report.ReportOptions.VersionRelease) + '.' +
      UTF8Encode(Report.ReportOptions.VersionBuild) + '</Version>');
{$ENDIF}
    WriteExpLn('</DocumentProperties>');
    WriteExpLn('<ExcelWorkbook xmlns="urn:schemas-microsoft-com:office:excel">');
    WriteExpLn('<ProtectStructure>False</ProtectStructure>');
    WriteExpLn('<ProtectWindows>False</ProtectWindows>');
    WriteExpLn('</ExcelWorkbook>');
    if FExportStyles then
    begin
      WriteExpLn('<Styles>');
      for x := 0 to FMatrix.StylesCount - 1 do
      begin
        EStyle := FMatrix.GetStyleById(x);
        s := 's' + IntToStr(x);
        WriteExpLn('<Style ss:ID="'+s+'">');
        if fsBold in EStyle.Font.Style then
          sb := ' ss:Bold="1"'
        else
          sb := '';
        if fsItalic in EStyle.Font.Style then
          si := ' ss:Italic="1"'
        else
          si := '';
        if fsUnderline in EStyle.Font.Style then
          su := ' ss:Underline="Single"'
        else
          su := '';
        if fsStrikeOut in EStyle.Font.Style then
          ss := ' ss:StrikeThrough="1"'
        else
          ss := '';
        WriteExpLn('<Font '+
          'ss:FontName="' + EStyle.Font.Name + '" '+
          'ss:Size="' + IntToStr(EStyle.Font.Size) + '" ' +
          'ss:Color="' + HTMLRGBColor(EStyle.Font.Color) + '"' + sb + si + su + ss + '/>');
        WriteExpLn('<Interior ss:Color="' + HTMLRGBColor(EStyle.Color) +
          '" ss:Pattern="Solid"/>');
        AlignFR2AlignExcel(EStyle.HAlign, EStyle.VAlign, Horiz, Vert, EStyle.Rotation);
        if (EStyle.Rotation > 0) and (EStyle.Rotation <= 90) then
          s := 'ss:Rotate="' + IntToStr(EStyle.Rotation) + '"'
        else  if (EStyle.Rotation < 360) and (EStyle.Rotation >= 270) then
          s := 'ss:Rotate="' + IntToStr(EStyle.Rotation - 360) + '"'
        else
          s := '';

        if EStyle.WordWrap then
          si := '" ss:WrapText="1" '
        else
          si := '" ss:WrapText="0" ';

        WriteExpLn('<Alignment ss:Horizontal="' + Horiz + '" ss:Vertical="' + Vert + si + s +'/>');
        WriteExpLn('<Borders>');
        if (ftLeft in EStyle.FrameTyp) then
          WriteExpLn('<Border ss:Position="Left"' + BorderProp(EStyle.LeftLine) + '/>');
        if (ftRight in EStyle.FrameTyp) then
          WriteExpLn('<Border ss:Position="Right"' + BorderProp(EStyle.RightLine) + '/>');
        if (ftTop in EStyle.FrameTyp) then
          WriteExpLn('<Border ss:Position="Top"' + BorderProp(EStyle.TopLine) + '/>');
        if (ftBottom in EStyle.FrameTyp) then
          WriteExpLn('<Border ss:Position="Bottom"' + BorderProp(EStyle.BottomLine) + '/>');
        WriteExpLn('</Borders>');

        if EStyle.DisplayFormat.DecimalSeparator = '' then
{$IFDEF DELPHI16}
          decsep := FormatSettings.DecimalSeparator
{$ELSE}
          decsep := DecimalSeparator
{$ENDIF}
        else
          decsep := EStyle.DisplayFormat.DecimalSeparator;

        if EStyle.DisplayFormat.ThousandSeparator = '' then
{$IFDEF DELPHI16}
          decsep := FormatSettings.ThousandSeparator
{$ELSE}
          decsep := ThousandSeparator
{$ENDIF}

        else
          decsep := EStyle.DisplayFormat.ThousandSeparator;

        if (EStyle.DisplayFormat.Kind = fkNumeric) and
          (EStyle.DisplayFormat.FormatStr <> '%2.2n') and
          (EStyle.DisplayFormat.FormatStr <> '') then
{$IFDEF Delphi12}
          WriteExpLn('<NumberFormat ss:Format="' + ConVertFormat(EStyle.DisplayFormat.FormatStr, decsep, thsep) + '"/>');
{$ELSE}
          WriteExpLn('<NumberFormat ss:Format="' + UTF8Encode(ConVertFormat(EStyle.DisplayFormat.FormatStr, decsep, thsep)) + '"/>');
{$ENDIF}
        WriteExpLn('</Style>');
      end;
      WriteExpLn('</Styles>');
    end;

    st := '';
    Page := 0;
    LastPrevRow := 0;
    IEMPage := FMatrix.IEPages[Page];
    if IEMPage <> nil then
      PrevPageName := IEMPage.PageName;
    StartWorkSheet(PrevPageName);
    for y := 0 to FMatrix.Height - 2 do
    begin
      drow := (FMatrix.GetYPosById(y + 1) - FMatrix.GetYPosById(y)) / Ydivider;
      WriteExpLn('<Row ss:Height="' + frFloat2Str(drow, 2) + '">');
      if (FMatrix.PagesCount > Page) or (FRowsCount > 0) then
        if (FMatrix.GetYPosById(y) >= FMatrix.GetPageBreak(Page)) or
        ((FRowsCount <= y + 1 - LastPrevRow) and (FRowsCount > 0)) then
        begin
          Inc(Page);
          PageBreak.Add(IntToStr(y + 1 - LastPrevRow));
          if ShowProgress then
          begin
            FProgress.Tick;
            if FProgress.Terminated then
              break;
          end;
        end;
      for x := 0 to FMatrix.Width - 1 do
      begin
        if ShowProgress then
          if FProgress.Terminated then
             break;
        si := ' ss:Index="' + IntToStr(x + 1) + '" ';
        i := FMatrix.GetCell(x, y);
        if (i <> -1) then
        begin
          Obj := FMatrix.GetObjectById(i);
          if Obj.Counter = 0 then
          begin
            FMatrix.GetObjectPos(i, fx, fy, dx, dy);
            Obj.Counter := 1;
            if Obj.IsText then
            begin
              if dx > 1 then
              begin
                s := 'ss:MergeAcross="' + IntToStr(dx - 1) + '" ';
                Inc(dx);
              end
              else
                s := '';
              if dy > 1 then
                sb := 'ss:MergeDown="' + IntToStr(dy - 1) + '" '
              else
                sb := '';
              if FExportStyles then
                st := 'ss:StyleID="' + 's' + IntToStr(Obj.StyleIndex) + '" '
              else
                st := '';
              WriteExpLn('<Cell' + si + s + sb + st + '>');

              s := TruncReturns(Obj.Memo.Text);
              if (Obj.Style.DisplayFormat.Kind = fkNumeric) and IsDigits(s) then
              begin

{$IFDEF DELPHI16}
                s := StringReplace(s, FormatSettings.ThousandSeparator, '', [rfReplaceAll]);
                s := StringReplace(s, FormatSettings.CurrencyString, '', [rfReplaceAll]);
                if Obj.Style.DisplayFormat.DecimalSeparator <> '' then
                  s := StringReplace(s, Obj.Style.DisplayFormat.DecimalSeparator, '.', [rfReplaceAll])
                else
                  s := StringReplace(s, FormatSettings.DecimalSeparator, '.', [rfReplaceAll]);
{$ELSE}
                s := StringReplace(s, ThousandSeparator, '', [rfReplaceAll]);
                s := StringReplace(s, CurrencyString, '', [rfReplaceAll]);
                if Obj.Style.DisplayFormat.DecimalSeparator <> '' then
                  s := StringReplace(s, Obj.Style.DisplayFormat.DecimalSeparator, '.', [rfReplaceAll])
                else
                  s := StringReplace(s, DecimalSeparator, '.', [rfReplaceAll]);
{$ENDIF}


                s := Trim(s);
                si := ' ss:Type="Number"';
{$IFDEF Delphi12}
                WriteExpLn('<Data' + si + '>' + s + '</Data>');
{$ELSE}
                WriteExpLn('<Data' + si + '>' + UTF8Encode(s) + '</Data>');
{$ENDIF}
              end
              else
              begin
                si := ' ss:Type="String"';
{$IFDEF Delphi12}
                s := ChangeReturns(s);
{$ELSE}
                s := ChangeReturns(UTF8Encode(s));
{$ENDIF}
                WriteExpLn('<Data' + si + '>' + s + '</Data>');
              end;
              WriteExpLn('</Cell>');
            end;
          end
        end
        else
          WriteExpLn('<Cell' + si + '/>');
      end;
      WriteExpLn('</Row>');


      if (FSplit = ssRowsCount) and
        ((FRowsCount <= y + 1 - LastPrevRow) and (FRowsCount > 0)) then
      begin
        FinishWorkSheet;
        StartWorkSheet('');
      end
      else
      begin
        IEMPage := FMatrix.IEPages[Page];
        if IEMPage <> nil then
          if ((FSplit = ssRPages) and (PrevpageName <> IEMPage.PageName))
            or ((FSplit = ssPrintOnPrev) and (PrevpageName <> IEMPage.PageName)
            and (Page > 0) and not IEMPage.PrintOnPreviousPage) then
          begin
            FinishWorkSheet;
            PrevpageName := IEMPage.PageName;
            StartWorkSheet(PrevPageName);
          end;
      end;

    end;

    FinishWorkSheet;
    WriteExpLn('</Workbook>');
  finally
    PageBreak.Free;
  end;
  if ShowProgress then
    FProgress.Free;
end;

function TfrxXMLExport.Start: Boolean;
begin
  FPaperNames := TStringList.Create;
  if (FileName <> '') or Assigned(Stream) then
  begin
    FFirstPage := True;
    FMatrix := TfrxIEMatrix.Create(UseFileCache, Report.EngineOptions.TempDir);
    FMatrix.DotMatrix := Report.DotMatrixReport;
    FMatrix.ShowProgress := ShowProgress;
    FMatrix.MaxCellHeight := XLMaxHeight * Ydivider;
    FMatrix.Background := FBackground and FEmptyLines;
    FMatrix.BackgroundImage := False;
    FMatrix.Printable := ExportNotPrintable;
    FMatrix.RichText := True;
    FMatrix.PlainRich := True;
    FMatrix.EmptyLines := FEmptyLines;
    FExportPageBreaks := FExportPageBreaks and FEmptyLines;
    if FWysiwyg then
      FMatrix.Inaccuracy := 0.5
    else
      FMatrix.Inaccuracy := 10;
    FMatrix.DeleteHTMLTags := True;
    Result := True
  end
  else
    Result := False;
end;

procedure TfrxXMLExport.StartPage(Page: TfrxReportPage; Index: Integer);
begin
  if FFirstPage then
  begin
    FFirstPage := False;
    FPageLeft := Page.LeftMargin;
    FPageTop := Page.TopMargin;
    FPageBottom := Page.BottomMargin;
    FPageRight := Page.RightMargin;
    FPageOrientation := Page.Orientation;
  end;
  if FPaperNames.IndexOf(Page.Name) = - 1 then
    begin
      FPaperNames.Add(Page.Name);
      SetLength(FPaperSizes, Length(FPaperSizes) + 1);
      FPaperSizes[Length(FPaperSizes) - 1] := Page.PaperSize;
      SetLength(FPaperOrientations, Length(FPaperOrientations) + 1);
      FPaperOrientations[Length(FPaperOrientations) - 1] := Page.Orientation;
    end;
end;

class function TfrxXMLExport.ExportDialogClass: TfrxBaseExportDialogClass;
begin
  Result := TfrxXMLExportDialog;
end;

procedure TfrxXMLExport.ExportObject(Obj: TfrxComponent);
var v: TfrxView;
begin
  if Obj.Page <> nil then
    Obj.Page.Top := FMatrix.Inaccuracy;
  if Obj.Name = '_pagebackground' then
    Exit;
  if Obj is TfrxView then
    begin
      v := TfrxView(Obj);
      if vsExport in v.Visibility then
        FMatrix.AddObject(TfrxView(Obj));
    end;
end;

procedure TfrxXMLExport.FinishPage(Page: TfrxReportPage; Index: Integer);
var
 IEMPage: TfrxIEMPage;
begin
  FMatrix.AddPage(Page.Orientation, Page.Width, Page.Height, Page.LeftMargin,
                  Page.TopMargin, Page.RightMargin, Page.BottomMargin, Page.MirrorMargins, Index);
  IEMPage := FMatrix.IEPages[Index];
  if IEMPage <> nil then
    with IEMPage do
    begin
       PageName := Page.Name;
       PrintOnPreviousPage := Page.PrintOnPreviousPage;
    end;

end;

procedure TfrxXMLExport.Finish;
var
  Exp: TStream;
//  Excel: Variant;
  CS: TCachedStream;
begin
  FMatrix.Prepare;
  try
    if Assigned(Stream) then
      Exp := Stream
    else
      Exp := IOTransport.GetStream(FileName);

    CS := TCachedStream.Create(Exp, False);

    try
      ExportPage(CS);
    finally
      CS.Free;

      if not Assigned(Stream) then
      begin
        IOTransport.DoFilterSave(Exp);
        IOTransport.FreeStream(Exp);
      end;
    end;
  except
    on e: Exception do
      case Report.EngineOptions.NewSilentMode of
        simSilent:        Report.Errors.Add(e.Message);
        simMessageBoxes:  frxErrorMsg(e.Message);
        simReThrow:       raise;
      end;
  end;
  FMatrix.Free;
  FPaperNames.Free;
  SetLength(FPaperSizes, 0);
  SetLength(FPaperOrientations, 0);
end;

procedure TfrxXMLExport.SetOpenExcel(const Value: Boolean);
begin
  OpenAfterExport := Value;
end;

procedure TfrxXMLExport.SetRowsCount(const Value: Integer);
begin
  FRowsCount := Value;
  if Value > 0 then
    FSplit := ssRowsCount
  else
  begin
    FSplit := ssNotSplit;
    FRowsCount := 0;
  end;
end;

end.
