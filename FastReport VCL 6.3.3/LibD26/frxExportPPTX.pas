
{******************************************}
{                                          }
{             FastReport v6.0              }
{               PPTX export                }
{                                          }
{         Copyright (c) 1998-2017          }
{             Fast Reports Inc.            }
{                                          }
{******************************************}

unit frxExportPPTX;

interface

{$I frx.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics,
  frxClass, ShellAPI, ComCtrls, frxZip, frxImageConverter,
  frxExportBaseDialog
{$IFDEF DELPHI16}
, System.UITypes
{$ENDIF}
;

type
{$IFDEF DELPHI16}
[ComponentPlatformsAttribute(pidWin32 or pidWin64)]
{$ENDIF}
  TfrxPPTXExport = class(TfrxBaseDialogExportFilter)
  private
    FDocFolder: string;
    FContentTypes: TStream; // [Content_Types].xml
    FPresentation: TStream; // ppt/presentation.xml
    FPresentationRels: TStream; // ppt/_rels/presentation.xml.rels
    FRels: TStream; // _rels/.rels
    FSlide: TStream; // ppt/slides/slideNNN.xml
    FSlideRels: TStream; // ppt/slides/_rels/slideNNN.xml.rels
    FSlideId: Integer;
    FObjectId: Integer;
    FPage: TfrxReportPage;
    FWidth, FHeight: Integer;
    FPictureType: TfrxPictureType;
    function SubPath(const s: string): string;
    procedure AddTextBox(Obj: TfrxCustomMemoView);
    procedure AddLine(Line: TfrxFrameLine; x, y, dx, dy: Integer);
    procedure AddPicture(Obj: TfrxView);
    function GetObjRect(Obj: TfrxView): TRect;
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
  frxOfficeOpen, frxExportPPTXDialog;

const
  LenFactor = 12000;
  FileExt: string = '.pptx';

{ TfrxPPTXExport }

function TfrxPPTXExport.GetObjRect(Obj: TfrxView): TRect;
begin
  Result.Left := Trunc(Obj.AbsLeft * LenFactor);
  Result.Top := Trunc(Obj.AbsTop * LenFactor);
  Result.Right := Result.Left + Trunc(Obj.Width * LenFactor);
  Result.Bottom := Result.Top + Trunc(Obj.Height * LenFactor);

  if Result.Left > Result.Right then Exchange(Result.Left, Result.Right);
  if Result.Top > Result.Bottom then Exchange(Result.Top, Result.Bottom);
end;

function TfrxPPTXExport.SubPath(const s: string): string;
begin
  Result := FDocFolder + '\' + s;
end;

class function TfrxPPTXExport.GetDescription: string;
begin
  Result := frxGet(9201);
end;

function TfrxPPTXExport.Start: Boolean;
begin
  Result := False; // Default

  if (FileName = '') and not Assigned(Stream) then
    Exit;

  Result := True;

  { file structure }
  FDocFolder := IOTransport.TempFilter.BasePath;
  CreateDirs(IOTransport.TempFilter, ['_rels', 'docProps', 'ppt', 'ppt\theme', 'ppt\_rels',
    'ppt\media', 'ppt\slides', 'ppt\slides\_rels', 'ppt\slideLayouts',
    'ppt\slideLayouts\_rels', 'ppt\slideMasters', 'ppt\slideMasters\_rels']);

  { [Content_Types].xml }

  FContentTypes := IOTransport.TempFilter.GetStream(SubPath('[Content_Types].xml'));
  //TFileStream.Create(SubPath('[Content_Types].xml'), fmCreate);
  with TfrxWriter.Create(FContentTypes) do
  begin
    Write(['<?xml version="1.0" encoding="UTF-8" standalone="yes"?>',
      '<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">',
      '<Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>',
      '<Default Extension="xml" ContentType="application/xml"/>',
      '<Default Extension="emf" ContentType="image/emf"/>',
      '<Override PartName="/ppt/presentation.xml"  ContentType="application/vnd.openxmlformats-officedocument.presentationml.presentation.main+xml"/>',
      '<Override PartName="/docProps/core.xml" ContentType="application/vnd.openxmlformats-package.core-properties+xml"/>',
      '<Override PartName="/docProps/app.xml" ContentType="application/vnd.openxmlformats-officedocument.extended-properties+xml"/>',
      '<Override PartName="/ppt/tableStyles.xml" ContentType="application/vnd.openxmlformats-officedocument.presentationml.tableStyles+xml"/>',
      '<Override PartName="/ppt/presProps.xml"  ContentType="application/vnd.openxmlformats-officedocument.presentationml.presProps+xml"/>',
      '<Override PartName="/ppt/viewProps.xml"  ContentType="application/vnd.openxmlformats-officedocument.presentationml.viewProps+xml"/>',
      '<Override PartName="/ppt/theme/theme.xml" ContentType="application/vnd.openxmlformats-officedocument.theme+xml"/>',
      '<Override PartName="/ppt/slideLayouts/slideLayout.xml"  ContentType="application/vnd.openxmlformats-officedocument.presentationml.slideLayout+xml"/>',
      '<Override PartName="/ppt/slideMasters/slideMaster.xml"  ContentType="application/vnd.openxmlformats-officedocument.presentationml.slideMaster+xml"/>']);

    Free;
  end;

  { _rels/.rels }

  FRels := IOTransport.TempFilter.GetStream(SubPath('_rels\.rels'));
  //TFileStream.Create(SubPath('_rels/.rels'), fmCreate);
  with TfrxWriter.Create(FRels) do
  begin
    Write(['<?xml version="1.0" encoding="UTF-8" standalone="yes"?>',
      '<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">',
      '<Relationship Id="rId1" Type="http://schemas.openxmlformats.org/package/2006/relationships/metadata/core-properties" Target="docProps/core.xml"/>',
      '<Relationship Id="rId2" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="ppt/presentation.xml"/>',
      '<Relationship Id="rId3" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/extended-properties"  Target="docProps/app.xml"/>',
      '</Relationships>']);

    Free;
  end;

  { docProps/core.xml }

  with TfrxFileWriter.Create(IOTransport.TempFilter.GetStream(SubPath('docProps\core.xml'))) do
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

  { docProps/app.xml }

  with TfrxFileWriter.Create(IOTransport.TempFilter.GetStream(SubPath('docProps\app.xml'))) do
  begin
    Write(['<?xml version="1.0" encoding="UTF-8" standalone="yes"?>',
      '<Properties xmlns="http://schemas.openxmlformats.org/officeDocument/2006/extended-properties" xmlns:vt="http://schemas.openxmlformats.org/officeDocument/2006/docPropsVTypes">',
      '<TotalTime>0</TotalTime><Words>0</Words><PresentationFormat>Arbitrary</PresentationFormat>',
      '<Paragraphs>0</Paragraphs><Slides>1</Slides><Notes>0</Notes><HiddenSlides>0</HiddenSlides>',
      '<MMClips>0</MMClips><ScaleCrop>false</ScaleCrop><HeadingPairs><vt:vector size="4" baseType="variant">',
      '<vt:variant><vt:lpstr>Subject</vt:lpstr></vt:variant><vt:variant><vt:i4>2</vt:i4></vt:variant>',
      '<vt:variant><vt:lpstr>Slide Headers</vt:lpstr></vt:variant><vt:variant><vt:i4>1</vt:i4></vt:variant>',
      '</vt:vector></HeadingPairs><TitlesOfParts><vt:vector size="3" baseType="lpstr"><vt:lpstr>Office Theme</vt:lpstr>',
      '<vt:lpstr>Office Theme</vt:lpstr><vt:lpstr>Slide 1</vt:lpstr></vt:vector>',
      '</TitlesOfParts><LinksUpToDate>false</LinksUpToDate><SharedDoc>false</SharedDoc>',
      '<HyperlinksChanged>false</HyperlinksChanged><AppVersion>12.0000</AppVersion></Properties>']);

    Free;
  end;

  { ppt/presentation.xml }

  FPresentation := IOTransport.TempFilter.GetStream(SubPath('ppt\presentation.xml'));
  //TFileStream.Create(SubPath('ppt/presentation.xml'), fmCreate);
  with TfrxWriter.Create(FPresentation) do
  begin
    Write(['<?xml version="1.0" encoding="UTF-8" standalone="yes"?>',
      '<p:presentation xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main"',
      ' xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" ',
      'xmlns:p="http://schemas.openxmlformats.org/presentationml/2006/main" ',
      'saveSubsetFonts="1"><p:sldMasterIdLst><p:sldMasterId id="2147483648" r:id="rId0"/>',
      '</p:sldMasterIdLst><p:sldIdLst>']);

    Free;
  end;

  { ppt/presProps.xml }

  with TfrxFileWriter.Create(IOTransport.TempFilter.GetStream(SubPath('ppt\presProps.xml'))) do
  begin
    Write(['<?xml version="1.0" encoding="UTF-8" standalone="yes"?>',
      '<p:presentationPr xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main"',
      ' xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" ',
      'xmlns:p="http://schemas.openxmlformats.org/presentationml/2006/main"/>']);

    Free;
  end;

  { ppt/tableStyles.xml }

  with TfrxFileWriter.Create(IOTransport.TempFilter.GetStream(SubPath('ppt\tableStyles.xml'))) do
  begin
    Write(['<?xml version="1.0" encoding="UTF-8" standalone="yes"?>',
      '<a:tblStyleLst xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main" def="{5C22544A-7EE6-4342-B048-85BDC9FD1C3A}"/>']);

    Free;
  end;

  { ppt/_rels/presentation.xml.rels }

  FPresentationRels := IOTransport.TempFilter.GetStream(SubPath('ppt\_rels\presentation.xml.rels'));
  //TFileStream.Create(SubPath('ppt/_rels/presentation.xml.rels'), fmCreate);

  with TfrxWriter.Create(FPresentationRels) do
  begin
    Write(['<?xml version="1.0" encoding="UTF-8" standalone="yes"?>',
      '<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">',
      '<Relationship Id="rId0" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/slideMaster" Target="slideMasters/slideMaster.xml"/>',
      '<Relationship Id="rIdpp" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/presProps" Target="presProps.xml"/>',
      '<Relationship Id="rIdvp" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/viewProps" Target="viewProps.xml"/>',
      '<Relationship Id="rIdt" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/theme" Target="theme/theme.xml"/>',
      '<Relationship Id="rIdts" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/tableStyles" Target="tableStyles.xml"/>']);

    Free;
  end;

  { ppt/slideLayouts/_rels/slideLayout.xml.rels }

  with TfrxFileWriter.Create(IOTransport.TempFilter.GetStream(SubPath('ppt\slideLayouts\_rels\slideLayout.xml.rels'))) do
  begin
    Write(['<?xml version="1.0" encoding="UTF-8" standalone="yes"?>',
      '<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">',
      '<Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/slideMaster" Target="../slideMasters/slideMaster.xml"/>',
      '</Relationships>']);

    Free;
  end;

  { ppt/slideLayouts/slideLayout.xml }

  with TfrxFileWriter.Create(IOTransport.TempFilter.GetStream(SubPath('ppt\slideLayouts\slideLayout.xml'))) do
  begin
    Write(['<?xml version="1.0" encoding="UTF-8" standalone="yes"?>',
      '<p:sldLayout xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main" ',
      'xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" ',
      'xmlns:p="http://schemas.openxmlformats.org/presentationml/2006/main" type="blank" preserve="1">',
      '<p:cSld name="Blank"><p:spTree><p:nvGrpSpPr><p:cNvPr id="1" name=""/><p:cNvGrpSpPr/>',
      '<p:nvPr/></p:nvGrpSpPr><p:grpSpPr><a:xfrm><a:off x="0" y="0"/><a:ext cx="0" cy="0"/>',
      '<a:chOff x="0" y="0"/><a:chExt cx="0" cy="0"/></a:xfrm></p:grpSpPr></p:spTree>',
      '</p:cSld><p:clrMapOvr><a:masterClrMapping/></p:clrMapOvr></p:sldLayout>']);

    Free;
  end;

  { ppt/slideMasters/_rels/slideMaster.xml.rels }

  with TfrxFileWriter.Create(IOTransport.TempFilter.GetStream(SubPath('ppt\slideMasters\_rels\slideMaster.xml.rels'))) do
  begin
    Write(['<?xml version="1.0" encoding="UTF-8" standalone="yes"?>',
      '<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">',
      '<Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/slideLayout" Target="../slideLayouts/slideLayout.xml"/>',
      '<Relationship Id="rId2" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/theme" Target="../theme/theme.xml"/>',
      '</Relationships>']);

    Free;
  end;

  { ppt/slideMasters/slideMaster.xml }

  with TfrxFileWriter.Create(IOTransport.TempFilter.GetStream(SubPath('ppt\slideMasters\slideMaster.xml'))) do
  begin
    Write(['<?xml version="1.0" encoding="UTF-8" standalone="yes"?>',
      '<p:sldMaster xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:p="http://schemas.openxmlformats.org/presentationml/2006/main">',
      '<p:cSld><p:bg><p:bgRef idx="1001"><a:schemeClr val="bg1"/></p:bgRef></p:bg><p:spTree>',
      '<p:nvGrpSpPr><p:cNvPr id="1" name=""/><p:cNvGrpSpPr/><p:nvPr/></p:nvGrpSpPr><p:grpSpPr>',
      '<a:xfrm><a:off x="0" y="0"/><a:ext cx="0" cy="0"/><a:chOff x="0" y="0"/><a:chExt cx="0" cy="0"/>',
      '</a:xfrm></p:grpSpPr></p:spTree></p:cSld>',
      '<p:clrMap bg1="lt1" tx1="dk1" bg2="lt2" tx2="dk2" accent1="accent1" ',
      'accent2="accent2" accent3="accent3" accent4="accent4" accent5="accent5" ',
      'accent6="accent6" hlink="hlink" folHlink="folHlink"/><p:sldLayoutIdLst>',
      '<p:sldLayoutId id="2147483649" r:id="rId1"/></p:sldLayoutIdLst><p:txStyles><p:titleStyle>',
      '</p:titleStyle><p:bodyStyle></p:bodyStyle><p:otherStyle><a:defPPr><a:defRPr ',
      'lang="en-US"/></a:defPPr></p:otherStyle></p:txStyles></p:sldMaster>']);

    Free;
  end;

  { ppt/theme/theme.xml }

  with TResourceStream.Create(HInstance, 'OfficeOpenTheme', 'XML') do
  begin
    SaveToStream(IOTransport.TempFilter.GetStream(SubPath('ppt\theme\theme.xml')));
    Free;
  end;

  { ppt/viewProps.xml }

  with TfrxFileWriter.Create(IOTransport.TempFilter.GetStream(SubPath('ppt\viewProps.xml'))) do
  begin
    Write('<?xml version="1.0" encoding="UTF-8" standalone="yes"?>' +
      '<p:viewPr xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:p="http://schemas.openxmlformats.org/presentationml/2006/main" lastView="sldThumbnailView">' +
      '<p:normalViewPr showOutlineIcons="0"><p:restoredLeft sz="15620" autoAdjust="0"/>' +
      '<p:restoredTop sz="94660" autoAdjust="0"/></p:normalViewPr><p:slideViewPr>' +
      '<p:cSldViewPr><p:cViewPr varScale="1"><p:scale><a:sx n="104" d="100"/>' +
      '<a:sy n="104" d="100"/></p:scale><p:origin x="-222" y="-90"/></p:cViewPr>' +
      '<p:guideLst><p:guide orient="horz" pos="2160"/><p:guide pos="2880"/>' +
      '</p:guideLst></p:cSldViewPr></p:slideViewPr><p:outlineViewPr><p:cViewPr>' +
      '<p:scale><a:sx n="33" d="100" /><a:sy n="33" d="100"/></p:scale><p:origin x="0" y="0"/>' +
      '</p:cViewPr></p:outlineViewPr><p:notesTextViewPr><p:cViewPr><p:scale><a:sx n="100" d="100"/>' +
      '<a:sy n="100" d="100"/></p:scale><p:origin x="0" y="0"/></p:cViewPr></p:notesTextViewPr>' +
      '<p:gridSpacing cx="73736200" cy="73736200"/></p:viewPr>');

    Free;
  end;
end;

procedure TfrxPPTXExport.StartPage(Page: TfrxReportPage; Index: Integer);
begin
  FSlideId := Index + 1;
  FPage := Page;
  FWidth := Trunc(Page.Width * LenFactor);
  FHeight := Trunc(Page.Height * LenFactor);

  { [Content_Types].xml }

  WriteStr(FContentTypes, Format('<Override PartName="/ppt/slides/slide%d.xml" ' +
    'ContentType="application/vnd.openxmlformats-officedocument.presentationml.' +
    'slide+xml"/>', [FSlideId]));

  { ppt/presentation.xml }

  WriteStr(FPresentation, Format('<p:sldId id="%d" r:id="rId%d"/>',
    [255 + FSlideId, FSlideId]));

  { ppt/_rels/presentation.xml.rels }

  WriteStr(FPresentationRels, Format('<Relationship Id="rId%d" ' +
    'Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/slide" ' +
    'Target="slides/slide%d.xml"/>', [FSlideId, FSlideId]));

  { ppt/slides/slideNNN.xml }

  FSlide := IOTransport.TempFilter.GetStream(SubPath(Format('ppt\slides\slide%d.xml', [FSlideId])));
  //TFileStream.Create(SubPath(Format('ppt/slides/slide%d.xml',
//    [FSlideId])), fmCreate);

  with TfrxWriter.Create(FSlide) do
  begin
    Write(['<?xml version="1.0" encoding="UTF-8" standalone="yes"?>',
      '<p:sld xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:p="http://schemas.openxmlformats.org/presentationml/2006/main">',
      '<p:cSld><p:spTree><p:nvGrpSpPr><p:cNvPr id="1" name=""/><p:cNvGrpSpPr/><p:nvPr/>',
      '</p:nvGrpSpPr><p:grpSpPr><a:xfrm><a:off x="0" y="0"/><a:ext cx="0" cy="0"/>',
      '<a:chOff x="0" y="0"/><a:chExt cx="0" cy="0"/></a:xfrm></p:grpSpPr>']);

    Free;
  end;

  { ppt/slides/_rels/slideNNN.xml.rels }

  FSlideRels := IOTransport.TempFilter.GetStream(SubPath(Format('ppt\slides\_rels\slide%d.xml.rels',
    [FSlideId])));
//  TFileStream.Create(SubPath(Format('ppt/slides/_rels/slide%d.xml.rels',
//    [FSlideId])), fmCreate);

  with TfrxWriter.Create(FSlideRels) do
  begin
    Write(['<?xml version="1.0" encoding="UTF-8" standalone="yes"?>',
      '<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">',
      '<Relationship Id="rId0" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/slideLayout" Target="../slideLayouts/slideLayout.xml"/>']);

    Free;
  end;
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
    Result := Format('%x%x%x%x%x%x', [R0,R1,G0,G1,B0,B1] );
  end;

  function BorderStyle(style: TfrxFrameStyle): String;
  begin
      case style of
      fsSolid:        Result := 'solid';
      fsDash:         Result := 'dashed';
      fsDot:          Result := 'sysDot';
      fsDashDot:      Result := 'sysDashDot';
      fsDashDotDot:   Result := 'sysDashDotDot';
      fsDouble:       Result := 'solid';
      fsAltDot:       Result := 'sysDot';
      fsSquare:       Result := 'solid';
      else            Result := 'solid';
      end;
  end;


procedure TfrxPPTXExport.AddLine(Line: TfrxFrameLine; x, y, dx, dy: Integer);
var
  Width:  Integer;
begin
  Inc(FObjectId);

  with TfrxWriter.Create(FSlide) do
  begin
    Width := Trunc(Line.Width * LenFactor);
    if Line.Style = fsDouble then Width := Width * 3;
    Write([Format('<p:cxnSp><p:nvCxnSpPr><p:cNvPr id="%d" name="Line%d"/><p:cNvCxnSpPr/>' +
      '<p:nvPr/></p:nvCxnSpPr><p:spPr><a:xfrm><a:off x="%d"  y="%d"/><a:ext cx="%d" ' +
      'cy="%d"/></a:xfrm><a:prstGeom prst="line"><a:avLst/></a:prstGeom><a:ln w="%d">' +
      '<a:solidFill><a:srgbClr val="%s"/></a:solidFill><a:prstDash val="%s"/></a:ln>' +
      '</p:spPr><p:style><a:lnRef idx="1"><a:schemeClr val="accent1"/></a:lnRef><a:fillRef idx="0">' +
      '<a:schemeClr val="accent1"/></a:fillRef><a:effectRef idx="0"><a:schemeClr val="accent1"/>' +
      '</a:effectRef><a:fontRef idx="minor"><a:schemeClr val="tx1"/></a:fontRef></p:style>' +
      '</p:cxnSp>', [FObjectId + 1, FObjectId, x, y, dx, dy, Width,
      ColorText(Line.Color), BorderStyle(Line.Style)])]);

    Free;
  end;
end;

procedure TfrxPPTXExport.AddPicture(Obj: TfrxView);
var
  m: TMetafile;
  c: TMetafileCanvas;
  Rid, Path: string;
  r: TRect;
  fr: frxClass.TfrxRect;
  dx, dy, fdx, fdy, dpx, dpy: Double;
begin
  if Obj.Height * Obj.Width = 0 then Exit;

  fr := Obj.GetRealBounds;
  dx := fr.Right - fr.Left;
  dy := fr.Bottom - fr.Top;

  if (dx = Obj.Width) or (Obj.AbsLeft = fr.Left) then
    fdx := 0
  else if Obj.AbsLeft + Obj.Width = fr.Right then
    fdx := dx - Obj.Width
  else
    fdx := (dx - Obj.Width) / 2;

  if (dy = Obj.Height) or (Obj.AbsTop = fr.Top) then
    fdy := 0
  else if Obj.AbsTop + Obj.Height = fr.Bottom then
    fdy := dy - Obj.Height
  else
    fdy := (dy - Obj.Height) / 2;

  dpx := Obj.AbsLeft - fdx;
  dpy := Obj.AbsTop - fdy;

  if Round(dx) = 0 then
    dx := 1;

  if dx < 0 then
    dpx := dpx + dx;

  if Round(dy) = 0 then
    dy := 1;

  if dy < 0 then
    dpy := dpy - dy;

  Inc(FObjectId);
  m := TMetafile.Create;
  m.Height := Round(Obj.Height);
  m.Width := Round(Obj.Width);
  c := TMetafileCanvas.Create(m, 0);

  try
    Obj.Draw(c, 1, 1, -dpx, -dpy);
  except
    // charts throw exceptions when numbers are malformed
  end;

  c.Free;
  Rid := 'rIdp' + IntToStr(FObjectId);
  r := GetObjRect(Obj);
  Path := 'image' + IntToStr(FObjectId) + '.emf';

  with TfrxWriter.Create(FSlide) do
  begin
    Write(Format('<p:pic><p:nvPicPr><p:cNvPr id="%d" name="Picture4" descr="Picture%d"/>' +
      '<p:cNvPicPr><a:picLocks noChangeAspect="1"/></p:cNvPicPr><p:nvPr/></p:nvPicPr>' +
      '<p:blipFill><a:blip r:embed="%s" cstate="print"/><a:stretch><a:fillRect/>' +
      '</a:stretch></p:blipFill><p:spPr><a:xfrm><a:off x="%d"  y="%d"/>' +
      '<a:ext cx="%d" cy="%d"/></a:xfrm><a:prstGeom prst="rect"><a:avLst/></a:prstGeom>' +
      '<a:noFill/></p:spPr></p:pic>', [FObjectId, FObjectId + 1, Rid, r.Left, r.Top,
      r.Right - r.Left + 1, r.Bottom - r.Top + 1]));

    Free;
  end;

  WriteStr(FSlideRels, Format('<Relationship Id="%s" Type="http://schemas.openxmlformats.' +
    'org/officeDocument/2006/relationships/image" Target="../media/%s"/>', [Rid, Path]));

  SaveGraphicAs(m, IOTransport.TempFilter.GetStream(SubPath('ppt\media\' + Path)), PictureType);
  m.Free;
end;

procedure TfrxPPTXExport.AddTextBox(Obj: TfrxCustomMemoView);
const
  HMap: array[0..3] of string = ('l', 'r', 'ctr', 'just');
  VMap: array[0..2] of string = ('t', 'b', 'ctr');

  function b2s(b: Boolean): string;
  begin
    if b then
      Result := '1'
    else
      Result := '0';
  end;

  function bs(b: Boolean; const s: string): string;
  begin
    if b then
      Result := s
    else
      Result := '';
  end;

var
  r: TRect;
  s: string;
begin
  Inc(FObjectId);
  r := GetObjRect(Obj);

  with TfrxWriter.Create(FSlide) do
  begin
    if Obj.Memo.Text <> '' then
      s := Obj.Memo.Text
    else
      s := ' ';

    if Obj.AllowHTMLTags then
      s := Obj.WrapText(False);

    Write('<p:sp>');
    Write('<p:nvSpPr><p:cNvPr id="%d" name="TextBox' +
      '%d"/><p:cNvSpPr><a:spLocks noGrp="1"/></p:cNvSpPr><p:nvPr>' +
      '<p:ph/></p:nvPr></p:nvSpPr>', [1 + FObjectId, FObjectId]);

    Write('<p:spPr><a:xfrm><a:off x="%d"  y="%d"/><a:ext cx="%d" cy="%d' +
      '"/></a:xfrm><a:prstGeom prst="rect"><a:avLst/></a:prstGeom>' +
      '%s</p:spPr>',
      [r.Left, r.Top, r.Right - r.Left + 1, r.Bottom - r.Top + 1,
      bs(Obj.Color <> clNone, Format('<a:solidFill><a:srgbClr val="%s"/></a:solidFill>',
      [ColorText(Obj.Color or $010101)]))]);
//      [RGBSwap(Obj.Color) or $010101]))]);

    Write(Format('<p:txBody><a:bodyPr vert="horz" lIns="45720" tIns="22860"' +
      ' rIns="45720" bIns="22860" rtlCol="0" anchor="%s"><a:normAutofit/></a:bodyPr>' +
      '<a:lstStyle/><a:p><a:pPr algn="%s"/><a:r><a:rPr lang="en-US"' +
      ' sz="%d" b="%s" i="%s" %s smtClean="0"><a:solidFill><a:srgbClr val="%s" ' +
      '/></a:solidFill><a:latin typeface="%s"/></a:rPr><a:t>', [VMap[Integer(Obj.VAlign)],
      HMap[Integer(Obj.HAlign)], Obj.Font.Size * 100,
      b2s(fsBold in Obj.Font.Style), b2s(fsItalic in Obj.Font.Style),
      bs(fsUnderline in Obj.Font.Style, 'u="sng"'),
      ColorText(Obj.Font.Color or $010101),
//      RGBSwap(Obj.Font.Color) or $010101,
      Obj.Font.Name]));

    // note: in unicode delphi12+ Utf8Encode has no effect: when converted to widestring it does utf8decode automatically
    Write(String(Utf8Encode(CleanTrash(Escape(s)))), {$IFDEF Delphi12}True{$ELSE}False{$ENDIF});
    Write('</a:t></a:r></a:p></p:txBody>');
    Write('</p:sp>');

    with Obj.Frame do
    begin
      if ftLeft in Typ then AddLine(LeftLine, r.Left, r.Top, 0, r.Bottom - r.Top + 1);
      if ftRight in Typ then AddLine(RightLine, r.Right, r.Top, 0, r.Bottom - r.Top + 1);
      if ftTop in Typ then AddLine(TopLine, r.Left, r.Top, r.Right - r.Left + 1, 0);
      if ftBottom in Typ then AddLine(BottomLine, r.Left, r.Bottom, r.Right - r.Left + 1, 0);
    end;

    Free;
  end;
end;

constructor TfrxPPTXExport.Create(Owner: TComponent);
begin
  inherited;
  DefaultExt := '.pptx';
  FilterDesc := frxGet(9205);
  FObjectId := 0;
end;

class function TfrxPPTXExport.ExportDialogClass: TfrxBaseExportDialogClass;
begin
  Result := TfrxPPTXExportDialog;
end;

procedure TfrxPPTXExport.ExportObject(Obj: TfrxComponent);
var
  v: TfrxView;
begin
  if not (Obj is TfrxView) then Exit;
  v := Obj as TfrxView;
  if (v.Name = '_pagebackground') or not (vsExport in v.Visibility) then
    Exit;

  if v is TfrxCustomMemoView then
    AddTextBox(v as TfrxCustomMemoView)
  else
    AddPicture(v);
end;

procedure TfrxPPTXExport.FinishPage(Page: TfrxReportPage; Index: Integer);
begin
  { ppt/slides/_rels/slideNNN.xml.rels }

  WriteStr(FSlideRels, '</Relationships>');

  { ppt/slides/slideNNN.xml }

  WriteStr(FSlide, '</p:spTree></p:cSld><p:clrMapOvr><a:masterClrMapping/></p:clrMapOvr></p:sld>');

  { close files }
  IOTransport.TempFilter.DoFilterSave(FSlideRels);
  IOTransport.TempFilter.DoFilterSave(FSlide);
end;

procedure TfrxPPTXExport.Finish;
var
  Zip: TfrxZipArchive;
  f: TStream;
  FileNames: TStrings;
begin
  WriteStr(FContentTypes, '</Types>');
  FileNames := TStringList.Create;
  { ppt/presentation.xml }

  with TfrxWriter.Create(FPresentation) do
  begin
    Write('</p:sldIdLst><p:sldSz cx="%d" cy="%d" type="custom"/>' +
      '<p:notesSz cx="6858000" cy="9144000"/><p:defaultTextStyle><a:defPPr><a:defRPr ' +
      'lang="en-US"/></a:defPPr></p:defaultTextStyle></p:presentation>',
      [FWidth, FHeight]);

    Free;
  end;

  { ppt/_rels/presentation.xml.rels }

  WriteStr(FPresentationRels, '</Relationships>');

  { close files }
  IOTransport.TempFilter.FilterAccess := faRead;
  IOTransport.TempFilter.LoadClosedStreams;
  FileNames.Clear;
  IOTransport.TempFilter.CopyStreamsNames(FileNames, True);
//  FContentTypes.Free;
//  FRels.Free;
//  FPresentation.Free;
//  FPresentationRels.Free;

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
      Zip.RootFolder := AnsiString(FDocFolder + '\');
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
  IOTransport.TempFilter.CloseAllStreams;
  FileNames.Free;
  DeleteFolder(FDocFolder);
end;

initialization

//FormatSettings.DecimalSeparator := '.';

end.
