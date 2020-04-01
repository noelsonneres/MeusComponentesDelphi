
{******************************************}
{                                          }
{             FastReport v6.0              }
{               DOCX export                }
{                                          }
{         Copyright (c) 1998-2017          }
{             Fast Reports Inc.            }
{                                          }
{******************************************}

unit frxExportDOCX;

interface

{$I frx.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics,
  frxClass, ShellAPI, frxZip, frxExportMatrix,
  frxImageConverter, frxExportBaseDialog
{$IFDEF DELPHI16}
, System.UITypes
{$ENDIF}
;

type
  TfrxDocxPage = record
    Width: Integer;
    Height: Integer;
    Margins: TRect;
  end;

{$IFDEF DELPHI16}
[ComponentPlatformsAttribute(pidWin32 or pidWin64)]
{$ENDIF}
  TfrxDOCXExport = class(TfrxBaseDialogExportFilter)
  private
    FDocFolder: string;
    FDocument: TStream; // word/document.xml
    FDocRels: TStream; // word/_rels/document.xml.rels
    FMatrix: TfrxIEMatrix;
    FLastPage: TfrxDocxPage;
    FPicNum: Integer;
    FURLNum: Integer;
    FFirstPage: Boolean;
    FPictureType: TfrxPictureType;
    function SubPath(const s: string): string;
    function SecPr: string;
  public
    constructor Create(Owner: TComponent); override;
    class function GetDescription: string; override;
    class function ExportDialogClass: TfrxBaseExportDialogClass; override;
    function Start: Boolean; override;
    procedure Finish; override;
    procedure StartPage(Page: TfrxReportPage; Index: Integer); override;
    procedure FinishPage(Page: TfrxReportPage; Index: Integer); override;
    procedure ExportObject(Obj: TfrxComponent); override;
  published
    property OpenAfterExport;
    property OverwritePrompt;
    property PictureType: TfrxPictureType read FPictureType write FPictureType;
  end;

implementation

uses
  frxUtils, frxFileUtils, frxUnicodeUtils, frxRes, frxrcExports, frxGraphicUtils,
  frxOfficeOpen, frxExportDOCXDialog;

const
  FileExt: string = '.docx';
  LenFactor: Double = 56.79;
  XFactor: Double = 15.50;
  YFactor: Double = 14.70;
  MMFactor: Double = 269.332;

{ TfrxDOCXExport }

function TfrxDOCXExport.SubPath(const s: string): string;
begin
  Result := FDocFolder + '/' + s;
end;

function TfrxDOCXExport.SecPr: string;
begin
  Result := Format('<w:sectPr><w:pgSz w:w="%d" w:h="%d"', [FLastPage.Width, FLastPage.Height]);
  if FLastPage.Width > FLastPage.Height then Result := Result + ' w:orient="landscape"';
  Result := Result + Format('/><w:pgMar w:top="%d" w:right="%d" w:bottom="%d" w:left="%d" w:header="720" w:footer="720" w:gutter="0"/>' +
                          '<w:cols w:space="720"/><w:noEndnote/></w:sectPr>',
                          [FLastPage.Margins.Top, FLastPage.Margins.Right, FLastPage.Margins.Bottom, FLastPage.Margins.Left]);
end;

class function TfrxDOCXExport.GetDescription: string;
begin
  Result := frxGet(9203);
end;

class function TfrxDOCXExport.ExportDialogClass: TfrxBaseExportDialogClass;
begin
  Result := TfrxDOCXExportDialog;
end;

function TfrxDOCXExport.Start: Boolean;
var
  TempStream: TStream;
begin
  Result := False; // Default

  if (FileName = '') and not Assigned(Stream) then
    Exit;

  Result := True;
  FPicNum := 1;
  FURLNum := 1;
  FFirstPage := True;

  { file structure }
  try
  FDocFolder := IOTransport.TempFilter.BasePath;
  CreateDirs(IOTransport.TempFilter, ['_rels', 'docProps', 'word', 'word/theme', 'word/_rels', 'word/media' ]);

  { [Content_Types].xml }
  TempStream := IOTransport.TempFilter.GetStream(SubPath('[Content_Types].xml'));
  with TfrxWriter.Create(TempStream) do
  begin
    Write(['<?xml version="1.0" encoding="UTF-8" standalone="yes"?>',
      '<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">',
      '<Default Extension="emf" ContentType="image/x-emf"/>',
      '<Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>',
      '<Default Extension="xml" ContentType="application/xml"/>',
      '<Override PartName="/word/document.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.document.main+xml"/>',
      '<Override PartName="/word/styles.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.styles+xml"/>',
      '<Override PartName="/docProps/app.xml" ContentType="application/vnd.openxmlformats-officedocument.extended-properties+xml"/>',
      '<Override PartName="/word/settings.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.settings+xml"/>',
//      '<Override PartName="/word/theme/theme1.xml" ContentType="application/vnd.openxmlformats-officedocument.theme+xml"/>',
      '<Override PartName="/word/fontTable.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.fontTable+xml"/>',
//      '<Override PartName="/word/webSettings.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.webSettings+xml"/>',
      '<Override PartName="/docProps/core.xml" ContentType="application/vnd.openxmlformats-package.core-properties+xml"/>',
      '</Types>']);

    Free;
  end;
  IOTransport.TempFilter.FreeStream(TempStream);

  { _rels/.rels }
  TempStream := IOTransport.TempFilter.GetStream(SubPath('_rels/.rels'));
  with TfrxWriter.Create(TempStream) do
  begin
    Write(['<?xml version="1.0" encoding="UTF-8" standalone="yes"?>',
      '<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">',
      '<Relationship Id="rId3" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/extended-properties" Target="docProps/app.xml"/>',
      '<Relationship Id="rId2" Type="http://schemas.openxmlformats.org/package/2006/relationships/metadata/core-properties" Target="docProps/core.xml"/>',
      '<Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="word/document.xml"/>',
      '</Relationships>']);

    Free;
  end;
  IOTransport.TempFilter.FreeStream(TempStream);
  { docProps/core.xml }
  TempStream := IOTransport.TempFilter.GetStream(SubPath('docProps/core.xml'));
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
      {$IfDef EXPORT_TEST}
      '<dcterms:created xsi:type="dcterms:W3CDTF">2019-01-12T11:06:45Z</dcterms:created>',
      '<dcterms:modified xsi:type="dcterms:W3CDTF">2019-01-12T11:06:45Z</dcterms:modified>',
      {$Else}
      '<dcterms:created xsi:type="dcterms:W3CDTF">' + FormatDateTime('yyyy-mm-dd"T"hh:nn:ss"Z"', DateTimeToUTC(Now)) + '</dcterms:created>',
      '<dcterms:modified xsi:type="dcterms:W3CDTF">' + FormatDateTime('yyyy-mm-dd"T"hh:nn:ss"Z"', DateTimeToUTC(Now)) + '</dcterms:modified>',
      {$EndIf}
      '</cp:coreProperties>'], True);

    Free;
  end;
  IOTransport.TempFilter.FreeStream(TempStream);
  { docProps/app.xml }
  TempStream := IOTransport.TempFilter.GetStream(SubPath('docProps/app.xml'));
  with TfrxWriter.Create(TempStream) do
  begin
    Write(['<?xml version="1.0" encoding="UTF-8" standalone="yes"?>',
      '<Properties xmlns="http://schemas.openxmlformats.org/officeDocument/2006/extended-properties" xmlns:vt="http://schemas.openxmlformats.org/officeDocument/2006/docPropsVTypes">',
      '<Template>Normal.dotm</Template>',
      '<TotalTime>1</TotalTime>',

      // todo: are these lines really needed ?
      //'<Pages>6</Pages>',
      //'<Words>2340</Words>',
      //'<Characters>13340</Characters>',
      //'<Lines>111</Lines>',
      //'<Paragraphs>31</Paragraphs>',
      //'<CharactersWithSpaces>15649</CharactersWithSpaces>',

      '<Application>FastReports</Application>',
      '<DocSecurity>0</DocSecurity>',
      '<ScaleCrop>false</ScaleCrop>',
      '<Company></Company>',
      '<LinksUpToDate>false</LinksUpToDate>',
      '<SharedDoc>false</SharedDoc>',
      '<HyperlinksChanged>false</HyperlinksChanged>',
      '<AppVersion>12.0000</AppVersion>',
      '</Properties>']);

    Free;
  end;
  IOTransport.TempFilter.FreeStream(TempStream);
  { word/_rels/document.xml.rels }
  FDocRels := IOTransport.TempFilter.GetStream(SubPath('word/_rels/document.xml.rels'));
  with TfrxWriter.Create(FDocRels) do
  begin
    Write(['<?xml version="1.0" encoding="UTF-8" standalone="yes"?>',
      '<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">',
//      '<Relationship Id="rId3" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/webSettings" Target="webSettings.xml"/>',
      '<Relationship Id="rId2" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/settings" Target="settings.xml"/>',
      '<Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/styles" Target="styles.xml"/>',
//      '<Relationship Id="rId5" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/theme" Target="theme/theme1.xml"/>',
      '<Relationship Id="rId4" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/fontTable" Target="fontTable.xml"/>']);

    Free;
  end;
  { word/webSettings.xml }
{
  with TfrxFileWriter.Create(SubPath('word/webSettings.xml')) do
  begin
    Write(['<?xml version="1.0" encoding="UTF-8" standalone="yes"?>',
      '<w:webSettings xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">',
      '<w:optimizeForBrowser/>',
      '</w:webSettings>']);

    Free;
  end;
}
  { word/styles.xml }
  TempStream := IOTransport.TempFilter.GetStream(SubPath('word/styles.xml'));
  with TResourceStream.Create(HInstance, 'OfficeOpenStyles', 'XML') do
  begin
    SaveToStream(TempStream);
    Free;
  end;
  IOTransport.TempFilter.FreeStream(TempStream);
  { word/fontTable.xml }
  TempStream := IOTransport.TempFilter.GetStream(SubPath('word/fontTable.xml'));
  with TResourceStream.Create(HInstance, 'DocxFontTable', 'XML') do
  begin
    SaveToStream(TempStream);
    Free;
  end;
  IOTransport.TempFilter.FreeStream(TempStream);
  { word/settings.xml }
  TempStream := IOTransport.TempFilter.GetStream(SubPath('word/settings.xml'));
  with TResourceStream.Create(HInstance, 'OfficeOpenSettings', 'XML') do
  begin
    SaveToStream(TempStream);
    Free;
  end;
  IOTransport.TempFilter.FreeStream(TempStream);
  { word/theme/theme1.xml }
{
  with TResourceStream.Create(HInstance, 'OfficeOpenTheme', 'XML') do
  begin
    SaveToFile(SubPath('word/theme/theme1.xml'));
    Free;
  end;
}
  { word/document.xml }
  FDocument := IOTransport.TempFilter.GetStream(SubPath('word/document.xml'));
  with TfrxWriter.Create(FDocument) do
  begin
    Write(['<?xml version="1.0" encoding="UTF-8" standalone="yes"?>',
      '<w:document xmlns:ve="http://schemas.openxmlformats.org/markup-compatibility/2006"',
      ' xmlns:o="urn:schemas-microsoft-com:office:office"',
      ' xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships"',
      ' xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math"',
      ' xmlns:v="urn:schemas-microsoft-com:vml"',
      ' xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing"',
      ' xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml">',
      '<w:body>']);

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

procedure TfrxDOCXExport.StartPage(Page: TfrxReportPage; Index: Integer);
begin
  FMatrix := TfrxIEMatrix.Create(UseFileCache, Report.EngineOptions.TempDir);

  with FMatrix do
  begin
    Background      := False;
    BackgroundImage := False;
    Printable       := ExportNotPrintable;
    RichText        := False;
    PlainRich       := False;
    Inaccuracy      := 2;
    DeleteHTMLTags  := False;
    Images          := True;
    WrapText        := False;
    ShowProgress    := False;
    EmptyLines      := True;
    BrushAsBitmap   := False;
    EMFPictures     := True;
    MaxCellWidth    := 500;
    MaxCellHeight   := 500;
  end;

  if not FFirstPage then
    try
    with TfrxWriter.Create(FDocument) do
    begin
      Write(['<w:p>',
        '<w:pPr><w:widowControl w:val="0"/><w:autoSpaceDE w:val="0"/>',
        '<w:autoSpaceDN w:val="0"/><w:adjustRightInd w:val="0"/><w:spacing w:after="0" w:line="240" w:lineRule="auto"/>',
        '<w:rPr><w:rFonts w:ascii="Tahoma" w:hAnsi="Tahoma" w:cs="Tahoma"/><w:sz w:val="24"/>',
        '<w:szCs w:val="24"/></w:rPr>', SecPr, '</w:pPr></w:p>']);

      Free;
    end
    except
      on e: Exception do
        case Report.EngineOptions.NewSilentMode of
          simSilent:        Report.Errors.Add(e.Message);
          simMessageBoxes:  frxErrorMsg(e.Message);
          simReThrow:       raise;
        end;
    end;

  FFirstPage := False;
end;

constructor TfrxDOCXExport.Create(Owner: TComponent);
begin
  inherited;
  DefaultExt := '.docx';
  FilterDesc := frxGet(9206);
end;

procedure TfrxDOCXExport.ExportObject(Obj: TfrxComponent);
var
  v: TfrxView;
begin
  if not (Obj is TfrxView) then
    Exit;

  v := Obj as TfrxView;

  if (v.Name = '_pagebackground') or not (vsExport in v.Visibility) then
    Exit;

  FMatrix.AddObject(v);
end;

procedure TfrxDOCXExport.FinishPage(Page: TfrxReportPage; Index: Integer);

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
    Result := Format('%x%x%x%x%x%x', [R0,R1,G0,G1,B0,B1] );
  end;

  function BorderStyle(style: TfrxFrameStyle): String;
  begin
      case style of
      fsSolid:        Result := 'single';
      fsDash:         Result := 'dashed';
      fsDot:          Result := 'dotted';
      fsDashDot:      Result := 'dashDot';
      fsDashDotDot:   Result := 'dashDotDot';
      fsDouble:       Result := 'double';
      fsAltDot:       Result := 'dashDot';
      fsSquare:       Result := 'thin';
      else            Result := 'thin';
      end;
  end;

  function GetBorder( fl: TfrxFrameLine; ex: Bool): string;
  begin
    if ex then
      Result := Format('w:val="%s" w:sz="%d" w:space="0" w:color="#%s"',
        [ BorderStyle(fl.Style), Trunc(fl.Width * 4), ColorText(fl.Color) ])
    else
      Result := 'w:val="nil"';
  end;

  function GetVAlign(a: TfrxVAlign): string;
  begin
    case a of
      vaTop: Result := 'top';
      vaBottom: Result := 'bottom';
      vaCenter: Result := 'center';
      else Result := 'top';
    end;
  end;

  function GetHAlign(a: TfrxHAlign): string;
  begin
    case a of
      haLeft: Result := 'left';
      haRight: Result := 'right';
      haCenter: Result := 'center';
      haBlock: Result := 'both';
      else Result := 'left';
    end;
  end;

  function BStr(b: Boolean; s: string): string;
  begin
    if b then
      Result := s
    else
      Result := '';
  end;

  function GetFont(f: TFont; SubType: TSubStyle = ssNormal): string;
  var
    st: string;
    FontName: String;
  begin
    case SubType of
      ssNormal: st:= 'baseline';
      ssSubscript: st := 'subscript';
      ssSuperscript: st := 'superscript';
    end;
{$IFDEF Delphi12}
    FontName := f.Name;
{$ELSE}
    FontName := UTF8Encode(f.Name);
{$ENDIF}
  //Result := Format('<w:rPr><w:rFonts w:ascii="%s" w:hAnsi="%s" w:cs="%s" w:eastAsia="%s" w:hint="eastAsia"/>%s<w:bCs/>%s%s<w:color w:val="#%.6X"/><w:w w:val="105"/>' +
    Result := Format('<w:rPr><w:rFonts w:ascii="%s" w:hAnsi="%s" w:cs="%s" w:eastAsia="%s"/>%s<w:bCs/>%s%s<w:color w:val="#%.6X"/><w:w w:val="105"/>' +
    '<w:sz w:val="%d"/><w:szCs w:val="%d"/>%s<w:vertAlign w:val="%s"/></w:rPr>',
    [FontName, FontName, FontName, FontName, BStr(fsBold in f.Style, '<w:b/>'), BStr(fsItalic in f.Style, '<w:i/>'), BStr(fsStrikeOut in f.Style, '<w:strike/>'), RGBSwap(f.Color), f.Size * 2, f.Size * 2, BStr(fsUnderline in f.Style, '<w:u w:val="single"/>'), st]);
  end;

  function GetMerging(r, c: Integer): string;
  var
    i, x, y, dx, dy: Integer;
  begin
    Result := '';
    i := FMatrix.GetCell(c, r);
    if i < 0 then
      Exit;

    FMatrix.GetObjectPos(i, x, y, dx, dy);

    if dy > 1 then
      if r = y then
        Result := '<w:vMerge w:val="restart"/>'
      else
        Result := '<w:vMerge/>';
  end;

  function GetText(const s: string): string;
  begin
    if s = '' then
      Result := ''
    else
      Result := '<w:t>' + Escape(s) + '</w:t>';
  end;

  function GetSpacedText(const s: string): string;
  begin
    if s = '' then
      Result := ''
    else
      Result := '<w:t xml:space="preserve">' + Escape(s) + '</w:t>';
  end;

  procedure TagToStyle(ATag: TfrxHTMLTag; AStyle: TfrxIEMStyle; var ASubType: TSubStyle);
  begin
    AStyle.Font.Style := ATag.Style;
    AStyle.Font.Color := ATag.Color;
    ASubType := ATag.SubType;
  end;

  function WriteTaggedText(AObj: TfrxIEMObject; AStyle: TfrxIEMStyle; AWriter: TfrxWriter): Boolean;
  var
    TagList: TfrxHTMLTagsList;
    sw: WideString;
    sChunk: String;
    i, iPos: Integer;
    PrevTag, Tag: TfrxHTMLTag;
    SaveFont: TFont;
    ASubType, SaveSubType: TSubStyle;
    bStyleChanged, bEOL, bEOF: Boolean;
  begin
    Result := False;
    ASubType := ssNormal;
    if not AObj.HTMLTags then
      Exit;

    SaveFont := TFont.Create;
    TagList := TfrxHTMLTagsList.Create;
    try
      SaveFont.Assign(AStyle.Font);
      SaveFont.Style := [fsBold];
      SaveSubType := ssNormal;
      sw := AObj.Memo.Text;
      TagList.ExpandHTMLTags(sw);
      if (TagList.Count = 0) or (TagList.Items[0].Count = 0) then
        Exit;

      PrevTag := TagList.Items[0].Items[0];
      TagToStyle(PrevTag, AStyle, ASubType);
      i := 1;
      iPos := 1;
      repeat
        Tag := TagList.Items[0].Items[i - 1];

        bEOF := i = Length(sw);
        bStyleChanged := (Tag.Style <> PrevTag.Style) or (Tag.Color <> PrevTag.Color) or (Tag.SubType <> PrevTag.SubType);
        bEOL := Copy(sw, i, Length(sLineBreak)) = sLineBreak;

        if bStyleChanged or bEOL or bEOF then
        begin
          sChunk := GetSpacedText(String(Utf8Encode(Copy(sw, iPos, i - iPos))));
          iPos := i;
          if sChunk <> '' then
            AWriter.Write(['<w:r>', GetFont(AStyle.Font, ASubType), '', sChunk, '</w:r>'], {$IFDEF Delphi12}True{$ELSE}False{$ENDIF});
        end;

        if bEOL then
        begin
          iPos := i + Length(sLineBreak);
          AWriter.Write(['<w:r>', GetFont(SaveFont, SaveSubType), BStr(i < Length(sw) - 1, '<w:br/>'), '</w:r>'], {$IFDEF Delphi12}True{$ELSE}False{$ENDIF});
        end;

        if bStyleChanged then
         TagToStyle(Tag, AStyle, ASubType);

        PrevTag := Tag;
        Inc(i);
      until bEOF;
      Result := True;
    finally
      FreeAndNil(TagList);
      FreeAndNil(SaveFont);
    end;
  end;

  function GetPicture(m: TMetafile; URL: string = ''): string;
  var
    w, h: Integer;
    id, pic: string;
  begin
    if m.Width = 0 then
    begin
      Result := '';
      Exit;
    end;

    w := Round(m.Width * 360000 / fr1cm{m.MMWidth * MMFactor});
    h := Round(m.Height * 360000 / fr1cm{m.MMHeight * MMFactor});
    id := 'picId' + IntToStr(FPicNum);
    pic := 'image' + IntToStr(FPicNum) + '.emf';

    with TfrxWriter.Create(FDocRels) do
    begin
      Write('<Relationship Id="%s" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/image"' +
        ' Target="media/%s"/>', [id, pic]);

      Free;
    end;
    SaveGraphicAs(m, IOTransport.TempFilter.GetStream(SubPath('word/media/' + pic)), PictureType);
    Inc(FPicNum);

    Result := Format('<w:drawing><wp:inline distT="0" distB="0" distL="0" distR="0">' +
      '<wp:extent cx="%d" cy="%d"/><wp:effectExtent l="0" t="0" r="0" b="0"/>' +
      '<wp:docPr id="1" name="Picture"'+ BStr(URL = '', '/') + '>' + URL + '<wp:cNvGraphicFramePr>' +
      '<a:graphicFrameLocks xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main" noChangeAspect="1"/>' +
      '</wp:cNvGraphicFramePr><a:graphic xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main">' +
      '<a:graphicData uri="http://schemas.openxmlformats.org/drawingml/2006/picture">' +
      '<pic:pic xmlns:pic="http://schemas.openxmlformats.org/drawingml/2006/picture">' +
      '<pic:nvPicPr><pic:cNvPr id="0" name="Picture"/><pic:cNvPicPr>' +
      '<a:picLocks noChangeAspect="1" noChangeArrowheads="1"/></pic:cNvPicPr></pic:nvPicPr>' +
      '<pic:blipFill><a:blip r:embed="%s"/><a:srcRect/><a:stretch><a:fillRect/></a:stretch></pic:blipFill>' +
      '<pic:spPr bwMode="auto"><a:xfrm><a:off x="0" y="0"/><a:ext cx="%d" cy="%d"/></a:xfrm>' +
      '<a:prstGeom prst="rect"><a:avLst/></a:prstGeom><a:noFill/><a:ln w="9525"><a:noFill/><a:miter lim="800000"/>' +
      '<a:headEnd/><a:tailEnd/></a:ln></pic:spPr></pic:pic></a:graphicData></a:graphic></wp:inline></w:drawing>',
      [w, h, id, w, h]);
  end;

  procedure WriteRels(URL: string);
  begin
    with TfrxWriter.Create(FDocRels) do
      begin
        Write('<Relationship Id="rURLId%d" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/hyperlink" Target="%s" TargetMode="External"/>',
              [FURLNum, URL]);
        Free;
      end;
    inc(FURLNum);
  end;

var
  i, r, c1, c2: Integer;
  Obj: TfrxIEMObject;
  w: Integer;
  s: TfrxIEMStyle;
  rotate, pPr, URL: String;
  Writer: TfrxWriter;
begin
  with FLastPage do
  begin
    Width := Round(Page.PaperWidth * LenFactor);
    Height := Round(Page.PaperHeight * LenFactor);

    with Margins do
    begin
      Left := Round(Page.LeftMargin * LenFactor);
      Right := Round(Page.RightMargin * LenFactor);
      Top := Round(Page.TopMargin * LenFactor);
      Bottom := Round(Page.BottomMargin * LenFactor);
    end;
  end;

  FMatrix.Prepare;

  for i := 0 to FMatrix.GetObjectsCount - 1 do
    FMatrix.GetObjectById(i).Counter := 0;
  try
  Writer := TfrxWriter.Create(FDocument);
  with Writer do
  begin
    Write('<w:tbl>');

    Write(['<w:tblPr><w:tblW w:w="0" w:type="auto"/><w:tblInd w:w="15" w:type="dxa"/>',
      '<w:tblLayout w:type="fixed"/><w:tblCellMar><w:left w:w="15" w:type="dxa"/>',
      '<w:right w:w="15" w:type="dxa"/></w:tblCellMar><w:tblLook w:val="0000"/>',
      '</w:tblPr>']);

    Write('<w:tblGrid>');

    for i := 0 to FMatrix.Width - 2 do
    begin
      w := Round(XFactor * (FMatrix.GetXPosById(i + 1) - FMatrix.GetXPosById(i)));
      Write('<w:gridCol w:w="%d"/>', [w]);
    end;

    Write('</w:tblGrid>');

    for r := 0 to FMatrix.Height - 2 do
    begin
      Write('<w:tr>');

      Write('<w:tblPrEx><w:tblCellMar><w:top w:w="0" w:type="dxa"/><w:bottom w:w="0" w:type="dxa"/>' +
        '</w:tblCellMar></w:tblPrEx><w:trPr><w:trHeight w:hRule="exact" w:val="%d"/></w:trPr>',
        [Round(YFactor * (FMatrix.GetYPosById(r + 1) - FMatrix.GetYPosById(r)))]);

      c1 := 0;
      while (c1 < FMatrix.Width - 1) and (c1 < 63) do
      begin
        c2 := c1;
        w := 0;

        with FMatrix do
          while (c2 < Width - 1) and (GetCell(c1, r) = GetCell(c2, r)) do
          begin
            Inc(w, Round(XFactor * (GetXPosById(c2 + 1) - GetXPosById(c2))));
            Inc(c2);
          end;

        Dec(c2);

        Write('<w:tc>');
        Write('<w:tcPr><w:tcW w:w="%d" w:type="dxa"/>', [w]);

        if c2 > c1 then
          Write('<w:gridSpan w:val="%d"/>', [c2 - c1 + 1]);

        Obj := FMatrix.GetObject(c1, r);
        s := FMatrix.GetStyle(c1, r);
        if s <> nil then
          Write('<w:tcMar><w:top w:w="%d" w:type="dxa"/><w:left w:w="%d" w:type="dxa"/><w:bottom w:w="%d" w:type="dxa"/><w:right w:w="%d" w:type="dxa"/></w:tcMar>',
                [Trunc((s.GapY - 1)/fr1in*1440), Trunc(s.GapX/fr1in*1440), Trunc((s.GapY - 1)/fr1in*1440), Trunc(s.GapX/fr1in*1440)]);

        Write(GetMerging(r, c1));

        if (s <> nil) then
          Write('<w:tcBorders><w:top %s/><w:left %s/><w:bottom %s/><w:right %s/></w:tcBorders>',
            [GetBorder(s.TopLine, ftTop in s.FrameTyp),
            GetBorder(s.LeftLine, ftLeft in s.FrameTyp),
            GetBorder(s.BottomLine, ftBottom in s.FrameTyp),
            GetBorder(s.RightLine, ftRight in s.FrameTyp)]);

        if Obj <> nil then begin
          if s.Color <> 0 then
            Write('<w:shd w:val="clear" w:color="auto" w:fill="#%.6X"/><w:vAlign w:val="%s"/>',
              [RGBSwap(s.Color), GetVAlign(s.VAlign)])
          else
            Write('<w:shd w:val="clear" w:color="auto" w:fill="auto"/><w:vAlign w:val="%s"/>',
              [GetVAlign(s.VAlign)]);
          if Obj.Style.Rotation <> 0 then begin
            case Obj.Style.Rotation of
              90:   rotate := 'btLr';
              270:  rotate := 'tbRlV';
            else
              rotate := 'lrTb';
            end;
            Write('<w:textDirection w:val="' + rotate + '" />');
          end;
        end;

        Write('</w:tcPr>');

        Write('<w:p>');

        pPr := '<w:pPr><w:widowControl w:val="0"/>' +
               '<w:autoSpaceDE w:val="0"/><w:autoSpaceDN w:val="0"/><w:adjustRightInd w:val="0"/>' +
               '<w:spacing w:before="29" w:after="0" w:line="213" w:lineRule="auto"/><w:ind w:left="15"/>';

        if (Obj <> nil) then
          if Obj.IsText then
            pPr := '<w:pPr><w:widowControl w:val="0"/>' +
                   '<w:autoSpaceDE w:val="0"/><w:autoSpaceDN w:val="0"/><w:adjustRightInd w:val="0"/>' +
                   '<w:spacing w:before="29" w:after="0" w:line="' +
                   IntToStr(Trunc((s.Font.Size + (Obj.LineSpacing - 1) * 0.95 / 96 * 72) * 20)) +
                   '" w:lineRule="exact"/><w:ind w:left="15"/><w:ind w:firstLine="' + IntToStr(Trunc(Obj.Style.ParagraphGap / 96 * 72 * 20)) + '"/>';

        Write(pPr);

        if Obj <> nil then
        begin
          Write('<w:jc w:val="%s"/>', [GetHAlign(s.HAlign)]);
          Write(GetFont(s.Font), {$IFDEF Delphi12}True{$ELSE}False{$ENDIF});
        end;

        Write('</w:pPr>');

        if (Obj <> nil) and (Obj.Counter = 0) then
          begin
          if (Obj.Metafile <> nil) then
            if Obj.Metafile.Width > 0 then
              begin
                URL := '';
                if Obj.URL <> '' then
                  begin
                    URL := Format('<a:hlinkClick xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main" r:id="rURLId%d"/></wp:docPr>', [FURLNum]);
                    WriteRels(Escape(Obj.URL));
                  end;
                Write(['<w:r>', GetFont(s.Font), GetPicture(Obj.Metafile, URL), '</w:r>'], {$IFDEF Delphi12}True{$ELSE}False{$ENDIF});
              end
          else
            begin
              if Obj.URL <> '' then
                begin
                  Write('<w:hyperlink r:id="rURLId%d">', [FURLNum]);
                  WriteRels(Escape(Obj.URL));
                end;

              if not Obj.HTMLTags or not WriteTaggedText(Obj, s, Writer) then
                for i := 0 to Obj.Memo.Count - 1 do
                  begin
                    // note: in unicode delphi12+ Utf8Encode has no effect: when converted to widestring it does utf8decode automatically
                    Write(['<w:r>', GetFont(s.Font), BStr((i > 0) and not ((Obj.Style.ParagraphGap <> 0) and (Obj.Memo.Count > 1) {and (i <> Obj.Memo.Count - 1)}), '<w:br/>'), GetText(String(Utf8Encode(Obj.Memo[i]))), '</w:r>'], {$IFDEF Delphi12}True{$ELSE}False{$ENDIF});
                    if (Obj.Style.ParagraphGap <> 0) and (Obj.Memo.Count > 1) and (i <> Obj.Memo.Count - 1) then
                      begin
                        if Obj.URL <> '' then
                          Write('</w:hyperlink>');
                        Write(['</w:p><w:p>', pPr]);
                        Write('<w:jc w:val="%s"/>', [GetHAlign(s.HAlign)]);
                        Write(GetFont(s.Font), {$IFDEF Delphi12}True{$ELSE}False{$ENDIF});
                        Write('</w:pPr>');
                        if Obj.URL <> '' then
                          begin
                            Write('<w:hyperlink r:id="rURLId%d">', [FURLNum]);
                            WriteRels(Escape(Obj.URL));
                           end;
                      end;
                  end;

              if Obj.URL <> '' then
                Write('</w:hyperlink>');
            end;
          end;
        Write('</w:p></w:tc>');
        c1 := c2 + 1;

        if Obj <> nil then
          Obj.Counter := 1;
      end;

      Write('</w:tr>');
    end;

    Write('</w:tbl>');
    Free;
  end
  except
      on e: Exception do
        case Report.EngineOptions.NewSilentMode of
          simSilent:        Report.Errors.Add(e.Message);
          simMessageBoxes:  frxErrorMsg(e.Message);
          simReThrow:       raise;
        end;
    end;

  FMatrix.Free;
end;

procedure TfrxDOCXExport.Finish;
var
  Zip: TfrxZipArchive;
  f: TStream;
  FileNames: TStrings;
begin
  try
  with TfrxWriter.Create(FDocRels) do
  begin
    Write('</Relationships>');
    Free;
  end;

  with TfrxWriter.Create(FDocument) do
  begin
    Write(['<w:p/>',
      SecPr, '</w:body></w:document>']);

    Free;
  end;
  IOTransport.TempFilter.FreeStream(FDocRels);
  IOTransport.TempFilter.FreeStream(FDocument);

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
      Zip.RootFolder := AnsiString(SubPath(''));
      Zip.SaveToStreamFromList(f, FileNames);
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

end.
