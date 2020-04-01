
{******************************************}
{                                          }
{             FastReport v5.0              }
{      Language resources management       }
{                                          }
{         Copyright (c) 1998-2014          }
{         by Alexander Tzyganenko,         }
{            Fast Reports Inc.             }
{                                          }
{******************************************}

unit frxRes;

interface

{$I frx.inc}

uses
  {$IFNDEF FPC}Windows,{$ENDIF}
  SysUtils, Classes, Controls, Graphics, Forms, TypInfo, Buttons
  {$IFDEF FPC}
  , LResources, LCLProc, LCLType, LazHelper
  {$ELSE}
  , frxUnicodeUtils, ImgList
  {$ENDIF}
{$IFDEF Delphi6}
, Variants
{$ENDIF}

{$IFDEF Delphi10}
, WideStrings
{$ENDIF}
;


type
  TfrxResources = class(TObject)
  private
    FDisabledButtonImages: TImageList;
    FMainButtonImages: TImageList;
    FNames: TStringList;
    FObjectImages: TImageList;
    FPreviewButtonImages: TImageList;
    FValues: TWideStrings;// TStringList;
    FWizardImages: TImageList;
    FLanguages: TStringList;
    FHelpFile: String;
    FCP: Cardinal;
    procedure BuildLanguagesList;
    function GetMainButtonImages: TImageList;
    function GetObjectImages: TImageList;
    function GetPreviewButtonImages: TImageList;
    function GetWizardImages: TImageList;
  public
    constructor Create;
    destructor Destroy; override;
    function Get(const StrName: String): String;
    procedure Add(const Ref, Str: String);
    procedure AddW(const Ref: String; Str: WideString);
    procedure AddStrings(const Str: String);
    procedure AddXML(const Str: AnsiString);
    procedure Clear;
    procedure LoadFromFile(const FileName: String);
    procedure LoadFromStream(Stream: TStream);
    procedure SetButtonImages(Images: TBitmap; Clear: Boolean = False);
    procedure SetObjectImages(Images: TBitmap; Clear: Boolean = False);
    procedure SetPreviewButtonImages(Images: TBitmap; Clear: Boolean = False);
    procedure SetWizardImages(Images: TBitmap; Clear: Boolean = False);
    procedure SetGlyph(Button: TSpeedButton; Index: Integer);
    procedure UpdateFSResources;
    procedure Help(Sender: TObject); overload;
    property DisabledButtonImages: TImageList read FDisabledButtonImages;
    property MainButtonImages: TImageList read GetMainButtonImages;
    property PreviewButtonImages: TImageList read GetPreviewButtonImages;
    property ObjectImages: TImageList read GetObjectImages;
    property WizardImages: TImageList read GetWizardImages;
    property Languages: TStringList read FLanguages;
    property HelpFile: String read FHelpFile write FHelpFile;
  end;

function frxResources: TfrxResources;
function frxGet(ID: Integer): String;


implementation

uses frxUtils, frxChm, fs_iconst, frxGZip, frxXML;

var
  FResources: TfrxResources = nil;

type
{$IFDEF DELPHI16}
  frxInteger = NativeInt;
{$ELSE}
  frxInteger = Integer;
{$ENDIF}
{ TfrxResources }

constructor TfrxResources.Create;
begin
  try
    inherited;
    FDisabledButtonImages := TImageList.Create(nil);
    FDisabledButtonImages.Width := 16;
    FDisabledButtonImages.Height := 16;
    FMainButtonImages := TImageList.Create(nil);
    FMainButtonImages.Width := 16;
    FMainButtonImages.Height := 16;
    FObjectImages := TImageList.Create(nil);
    FObjectImages.Width := 16;
    FObjectImages.Height := 16;
    FPreviewButtonImages := TImageList.Create(nil);
    FPreviewButtonImages.Width := 16;
    FPreviewButtonImages.Height := 16;
    FWizardImages := TImageList.Create(nil);
    FWizardImages.Width := 32;
    FWizardImages.Height := 32;
    FNames := TStringList.Create;
{$IFDEF Delphi10}
    FValues := TfrxWideStrings.Create;
{$ELSE}
    FValues := TWideStrings.Create;
{$ENDIF}
    FNames.Sorted := True;
    FLanguages := TStringList.Create;
    HelpFile := 'FRUser.chm';
    FCP := 0;
    BuildLanguagesList;
  finally
  end;
end;

destructor TfrxResources.Destroy;
begin
  FLanguages.Free;
  FDisabledButtonImages.Free;
  FMainButtonImages.Free;
  FObjectImages.Free;
  FPreviewButtonImages.Free;
  FWizardImages.Free;
  FNames.Free;
  FValues.Free;
  inherited;
end;

procedure TfrxResources.AddW(const Ref: String; Str: WideString);
var
  i: Integer;
begin
  i := FNames.IndexOf(Ref);
  if i = -1 then
  begin
    FNames.AddObject(Ref, Pointer(FValues.Count));
    FValues.Add(Str);
  end
  else
    FValues[frxInteger(FNames.Objects[i])] := Str;
end;

procedure TfrxResources.Add(const Ref, Str: String);
begin
{$IFDEF Delphi12}
  AddW(Ref, Str);
{$ELSE}
  AddW(Ref, WideString(AnsiToUnicode(Str, DEFAULT_CHARSET, FCP)));
{$ENDIF}
end;

procedure TfrxResources.AddStrings(const Str: String);
var
  i: Integer;
  sl: TWideStrings;
  nm, vl: WideString;
begin
{$IFDEF Delphi10}
  sl := TfrxWideStrings.Create;
{$ELSE}
  sl := TWideStrings.Create;
{$ENDIF}
  sl.Text := Str;
  for i := 0 to sl.Count - 1 do
  begin
    nm := sl[i];
    vl := Copy(nm, Pos('=', nm) + 1, MaxInt);
    nm := Copy(nm, 1, Pos('=', nm) - 1);
    if (nm <> '') and (vl <> '') then
      Add(nm, vl);
  end;
  sl.Free;
end;

procedure TfrxResources.AddXML(const Str: AnsiString);
var
  Stream: TStringStream;
begin
  Stream := TStringStream.Create({$IFDEF Delphi12}'', TEncoding.UTF8{$ELSE}Str{$ENDIF});
{$IFDEF Delphi12}
  Stream.Write(Str[1], Length(Str));
  Stream.Position := 0;
{$ENDIF}
  LoadFromStream(Stream);
  Stream.Free;
end;

procedure TfrxResources.Clear;
begin
  FNames.Clear;
  FValues.Clear;
end;

function TfrxResources.Get(const StrName: String): String;
var
  i: Integer;
begin
  i := FNames.IndexOf(StrName);
  if i <> -1 then
{$IFDEF Delphi12}
    Result :=  FValues[frxInteger(FNames.Objects[i])] else //_UnicodeToAnsi(FValues[Integer(FNames.Objects[i])], DEFAULT_CHARSET, FCP) else
    Result := StrName;
{$ELSE}
    Result := _UnicodeToAnsi(FValues[frxInteger(FNames.Objects[i])], DEFAULT_CHARSET, FCP) else
    Result := StrName;
{$ENDIF}
  if (Result <> '') and (Result[1] = '!') then
    Delete(Result, 1, 1);
end;


function TfrxResources.GetMainButtonImages: TImageList;
var
  Images: TBitmap;
  stm: TMemoryStream;
  res: TResourceStream;
begin
  if FMainButtonImages.Count = 0 then
  begin
    Images := TBitmap.Create;
    stm := TMemoryStream.Create;
    res := TResourceStream.Create(hInstance, 'DesgnButtons', RT_RCDATA);
    try
      frxDecompressStream(res, stm);
      stm.Position := 0;
      Images.LoadFromStream(stm);
      SetButtonImages(Images);
    finally
      stm.Free;
      res.Free;
      Images.Free;
    end;
  end;

  Result := FMainButtonImages;
end;

function TfrxResources.GetPreviewButtonImages: TImageList;
var
  Images: TBitmap;
  stm: TMemoryStream;
  res: TResourceStream;
begin
  if FPreviewButtonImages.Count = 0 then
  begin
    Images := TBitmap.Create;
    stm := TMemoryStream.Create;
    res := TResourceStream.Create(hInstance, 'PreviewButtons', RT_RCDATA);
    try
      frxDecompressStream(res, stm);
      stm.Position := 0;
      Images.LoadFromStream(stm);
      SetPreviewButtonImages(Images);
    finally
      stm.Free;
      res.Free;
      Images.Free;
    end;
  end;

  Result := FPreviewButtonImages;
end;

function TfrxResources.GetObjectImages: TImageList;
var
  Images: TBitmap;
  stm: TMemoryStream;
  res: TResourceStream;
begin
  if FObjectImages.Count = 0 then
  begin
    Images := TBitmap.Create;
    stm := TMemoryStream.Create;
    res := TResourceStream.Create(hInstance, 'ObjectButtons', RT_RCDATA);
    try
      frxDecompressStream(res, stm);
      stm.Position := 0;
      Images.LoadFromStream(stm);
      SetObjectImages(Images);
    finally
      stm.Free;
      res.Free;
      Images.Free;
    end;
  end;

  Result := FObjectImages;
end;

function TfrxResources.GetWizardImages: TImageList;
var
  Images: TBitmap;
  stm: TMemoryStream;
  res: TResourceStream;
begin
  if FWizardImages.Count = 0 then
  begin
    Images := TBitmap.Create;
    stm := TMemoryStream.Create;
    res := TResourceStream.Create(hInstance, 'WizardButtons', RT_RCDATA);
    try
      frxDecompressStream(res, stm);
      stm.Position := 0;
      Images.LoadFromStream(stm);
      SetWizardImages(Images);
    finally
      stm.Free;
      res.Free;
      Images.Free;
    end;
  end;

  Result := FWizardImages;
end;

procedure TfrxResources.SetButtonImages(Images: TBitmap; Clear: Boolean = False);
begin
  if Clear then
  begin
    FMainButtonImages.Clear;
    FDisabledButtonImages.Clear;
  end;
  frxAssignImages(Images, 16, 16, FMainButtonImages, FDisabledButtonImages);
end;

procedure TfrxResources.SetObjectImages(Images: TBitmap; Clear: Boolean = False);
begin
  if Clear then
    FObjectImages.Clear;
  frxAssignImages(Images, 16, 16, FObjectImages);
end;

procedure TfrxResources.SetPreviewButtonImages(Images: TBitmap; Clear: Boolean = False);
begin
  if Clear then
    FPreviewButtonImages.Clear;
  frxAssignImages(Images, 16, 16, FPreviewButtonImages);
end;

procedure TfrxResources.SetWizardImages(Images: TBitmap; Clear: Boolean = False);
begin
  if Clear then
    FWizardImages.Clear;
  frxAssignImages(Images, 32, 32, FWizardImages);
end;

procedure TfrxResources.SetGlyph(Button: TSpeedButton; Index: Integer);
var
  b: TBitmap;
begin
  b := TBitmap.Create;
  b.Width := 32;
  b.Height := 16;
  b.Canvas.Brush.Color := clOlive;
  b.Canvas.FillRect(Rect(0, 0, 32, 16));
  FMainButtonImages.Draw(b.Canvas, 0, 0, Index);
  FDisabledButtonImages.Draw(b.Canvas, 16, 0, Index);
  Button.Glyph := b;
  b.Free;
end;

procedure TfrxResources.LoadFromFile(const FileName: String);
var
  f: TFileStream;
begin
  if FileExists(FileName) then
  begin
    f := TFileStream.Create(FileName, fmOpenRead or fmShareDenyNone);
    try
      LoadFromStream(f);
    finally
      f.Free;
    end;
  end;
end;

procedure TfrxResources.LoadFromStream(Stream: TStream);
var
  FXMLRes: TfrxXMLDocument;
  idx: Integer;
begin
  FXMLRes := TfrxXMLDocument.Create;
  FXMLRes.LoadFromStream(Stream);
  try
    with FXMLRes.Root do
    begin
      if Name = 'Resources' then
      begin
        FCP := StrToInt(Prop['CodePage']);
        for idx := 0 to  Count - 1 do
          if Items[idx].Name = 'StrRes' then
{$IFDEF Delphi12}
          if not FXMLRes.OldVersion then
            Self.AddW(Items[idx].Prop['Name'], frxXMLToStr(Items[idx].Prop['Text'])) else
{$ENDIF}
{$IFDEF FPC}
            Self.AddW(Items[idx].Prop['Name'], AnsiString(frxXMLToStr(Items[idx].Prop['Text'])));
{$ELSE}
            Self.AddW(Items[idx].Prop['Name'], UTF8Decode(AnsiString(frxXMLToStr(Items[idx].Prop['Text']))));
{$ENDIF}

      end;
    end;
  finally
    FXMLRes.Free;
  end;
  UpdateFSResources;
end;

procedure TfrxResources.UpdateFSResources;
begin
  SLangNotFound := Get('SLangNotFound');
  SInvalidLanguage := Get('SInvalidLanguage');
  SIdRedeclared := Get('SIdRedeclared');
  SUnknownType := Get('SUnknownType');
  SIncompatibleTypes := Get('SIncompatibleTypes');
  SIdUndeclared := Get('SIdUndeclared');
  SClassRequired := Get('SClassRequired');
  SIndexRequired := Get('SIndexRequired');
  SStringError := Get('SStringError');
  SClassError := Get('SClassError');
  SArrayRequired := Get('SArrayRequired');
  SVarRequired := Get('SVarRequired');
  SNotEnoughParams := Get('SNotEnoughParams');
  STooManyParams := Get('STooManyParams');
  SLeftCantAssigned := Get('SLeftCantAssigned');
  SForError := Get('SForError');
  SEventError := Get('SEventError');
end;

type
  THelpTopic = record
    Sender: String;
    Topic: String;
  end;

const
  helpTopicsCount = 17;
  helpTopics: array[0..helpTopicsCount - 1] of THelpTopic =
   (
    (Sender: 'TfrxDesignerForm'; Topic: 'Designer.htm'),
    (Sender: 'TfrxOptionsEditor'; Topic: 'Designer_options.htm'),
    (Sender: 'TfrxReportEditorForm'; Topic: 'Report_options.htm'),
    (Sender: 'TfrxPageEditorForm'; Topic: 'Page_options.htm'),
    (Sender: 'TfrxCrossEditorForm'; Topic: 'Cross_tab_reports.htm'),
    (Sender: 'TfrxChartEditorForm'; Topic: 'Diagrams.htm'),
    (Sender: 'TfrxSyntaxMemo'; Topic: 'Script.htm'),
    (Sender: 'TfrxDialogPage'; Topic: 'Dialogue_forms.htm'),
    (Sender: 'TfrxDialogComponent'; Topic: 'Data_access_components.htm'),
    (Sender: 'TfrxVarEditorForm'; Topic: 'Variables.htm'),
    (Sender: 'TfrxHighlightEditorForm'; Topic: 'Conditional_highlighting.htm'),
    (Sender: 'TfrxSysMemoEditorForm'; Topic: 'Inserting_aggregate_function.htm'),
    (Sender: 'TfrxFormatEditorForm'; Topic: 'Values_formatting.htm'),
    (Sender: 'TfrxGroupEditorForm'; Topic: 'Report_with_groups.htm'),
    (Sender: 'TfrxPictureEditorForm'; Topic: 'Picture_object.htm'),
    (Sender: 'TfrxMemoEditorForm'; Topic: 'Text_object.htm'),
    (Sender: 'TfrxSQLEditorForm'; Topic: 'TfrxADOQuery.htm')
   );




procedure TfrxResources.Help(Sender: TObject);
{$IFNDEF FPC}
var
  i: Integer;
  topic: String;
{$ENDIF}
begin
  {$IFDEF FPC}
  {$note TfrxResources.Help not implemented.}
  {$ELSE}
  topic := '';
  if Sender <> nil then
    for i := 0 to helpTopicsCount - 1 do
      if CompareText(helpTopics[i].Sender, Sender.ClassName) = 0 then
        topic := '::/' + helpTopics[i].Topic;

  frxDisplayHHTopic(Application.Handle, ExtractFilePath(Application.ExeName) + FHelpFile + topic);

{$ENDIF}
end;

procedure TfrxResources.BuildLanguagesList;
var
  i: Integer;
  SRec: TSearchRec;
  Dir: String;
  s: String;
begin
  Dir := GetAppPath;
  FLanguages.Clear;
  i := FindFirst(Dir + '*.frc', faAnyFile, SRec);
  try
    while i = 0 do
    begin
      s := LowerCase(SRec.Name);
      s := UpperCase(Copy(s, 1, 1)) + Copy(s, 2, Length(s) - 1);
      s := StringReplace(s, '.frc', '', []);
      FLanguages.Add(s);
      i := FindNext(SRec);
    end;
    FLanguages.Sort;
  finally
    FindClose(Srec);
  end;
end;


function frxResources: TfrxResources;
begin
  if FResources = nil then
    FResources := TfrxResources.Create;
  Result := FResources;
end;

function frxGet(ID: Integer): String;
begin
  Result := frxResources.Get(IntToStr(ID));
end;


initialization

finalization
  if FResources <> nil then
    FResources.Free;
  FResources := nil;

end.
