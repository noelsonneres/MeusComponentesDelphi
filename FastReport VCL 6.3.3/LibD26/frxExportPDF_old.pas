
{******************************************}
{                                          }
{             FastReport v5.0              }
{            PDF export filter             }
{                                          }
{         Copyright (c) 1998-2014          }
{          by Alexander Fediachov,         }
{             Fast Reports Inc.            }
{                                          }
{******************************************}

unit frxExportPDF;

interface

{$I frx.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComObj, Printers, frxClass, JPEG, ShellAPI,
  ComCtrls, frxPDFFile
{$IFDEF Delphi6}, Variants {$ENDIF};

type
  TfrxPDFExportDialog = class(TForm)
    PageControl1: TPageControl;
    ExportPage: TTabSheet;
    InfoPage: TTabSheet;
    SecurityPage: TTabSheet;
    ViewerPage: TTabSheet;
    OkB: TButton;
    CancelB: TButton;
    SaveDialog1: TSaveDialog;
    OpenCB: TCheckBox;
    GroupQuality: TGroupBox;
    CompressedCB: TCheckBox;
    EmbeddedCB: TCheckBox;
    PrintOptCB: TCheckBox;
    OutlineCB: TCheckBox;
    BackgrCB: TCheckBox;
    GroupPageRange: TGroupBox;
    DescrL: TLabel;
    AllRB: TRadioButton;
    CurPageRB: TRadioButton;
    PageNumbersRB: TRadioButton;
    PageNumbersE: TEdit;
    SecGB: TGroupBox;
    OwnPassL: TLabel;
    UserPassL: TLabel;
    OwnPassE: TEdit;
    UserPassE: TEdit;
    PermGB: TGroupBox;
    PrintCB: TCheckBox;
    ModCB: TCheckBox;
    CopyCB: TCheckBox;
    AnnotCB: TCheckBox;
    DocInfoGB: TGroupBox;
    TitleL: TLabel;
    TitleE: TEdit;
    AuthorE: TEdit;
    AuthorL: TLabel;
    SubjectL: TLabel;
    SubjectE: TEdit;
    KeywordsL: TLabel;
    KeywordsE: TEdit;
    CreatorE: TEdit;
    CreatorL: TLabel;
    ProducerL: TLabel;
    ProducerE: TEdit;
    ViewerGB: TGroupBox;
    HideToolbarCB: TCheckBox;
    HideMenubarCB: TCheckBox;
    HideWindowUICB: TCheckBox;
    FitWindowCB: TCheckBox;
    CenterWindowCB: TCheckBox;
    PrintScalingCB: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure PageNumbersEChange(Sender: TObject);
    procedure PageNumbersEKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  end;

  TfrxPDFExport = class(TfrxCustomExportFilter)
  private
    FCompressed: Boolean;
    FEmbedded: Boolean;
    FOpenAfterExport: Boolean;
    FPDF: TfrxPDFFile;
    FPDFpage: TfrxPDFPage;
    FPrintOpt: Boolean;
    FOutline: Boolean;
    FSubject: WideString;
    FAuthor: WideString;
    FBackground: Boolean;
    FCreator: WideString;
    FTags: Boolean;
    FProtection: Boolean;
    FUserPassword: AnsiString;
    FOwnerPassword: AnsiString;
    FProtectionFlags: TfrxPDFEncBits;
    FKeywords: WideString;
    FTitle: WideString;
    FProducer: WideString;
    FPrintScaling: Boolean;
    FFitWindow: Boolean;
    FHideMenubar: Boolean;
    FCenterWindow: Boolean;
    FHideWindowUI: Boolean;
    FHideToolbar: Boolean;
  public
    constructor Create(AOwner: TComponent); override;
    class function GetDescription: String; override;
    function ShowModal: TModalResult; override;
    function Start: Boolean; override;
    procedure ExportObject(Obj: TfrxComponent); override;
    procedure Finish; override;
    procedure StartPage(Page: TfrxReportPage; Index: Integer); override;
  published
    property Compressed: Boolean read FCompressed write FCompressed default True;
    property EmbeddedFonts: Boolean read FEmbedded write FEmbedded default False;
    property OpenAfterExport: Boolean read FOpenAfterExport
      write FOpenAfterExport default False;
    property PrintOptimized: Boolean read FPrintOpt write FPrintOpt;
    property Outline: Boolean read FOutline write FOutline;
    property Background: Boolean read FBackground write FBackground;
    property HTMLTags: Boolean read FTags write FTags;
    property OverwritePrompt;

    property Title: WideString read FTitle write FTitle;
    property Author: WideString read FAuthor write FAuthor;
    property Subject: WideString read FSubject write FSubject;
    property Keywords: WideString read FKeywords write FKeywords;
    property Creator: WideString read FCreator write FCreator;
    property Producer: WideString read FProducer write FProducer;

    property UserPassword: AnsiString read FUserPassword write FUserPassword;
    property OwnerPassword: AnsiString read FOwnerPassword write FOwnerPassword;
    property ProtectionFlags: TfrxPDFEncBits read FProtectionFlags write FProtectionFlags;

    property HideToolbar: Boolean read FHideToolbar write FHideToolbar;
    property HideMenubar: Boolean read FHideMenubar write FHideMenubar;
    property HideWindowUI: Boolean read FHideWindowUI write FHideWindowUI;
    property FitWindow: Boolean read FFitWindow write FFitWindow;
    property CenterWindow: Boolean read FCenterWindow write FCenterWindow;
    property PrintScaling: Boolean read FPrintScaling write FPrintScaling;
  end;

implementation

uses frxUtils, frxUnicodeUtils, frxFileUtils, frxRes, frxrcExports;

{$R *.dfm}

{ TfrxPDFExport }

constructor TfrxPDFExport.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCompressed := True;
  FPrintOpt := False;
  FAuthor := 'FastReport';
  FSubject := 'FastReport PDF export';
  FBackground := False;
  FCreator := 'FastReport';
  FTags := True;
  FProtection := False;
  FUserPassword := '';
  FOwnerPassword := '';
  FProducer := '';
  FKeywords := '';
  FProtectionFlags := [ePrint, eModify, eCopy, eAnnot];
  FilterDesc := frxGet(8707);
  DefaultExt := frxGet(8708);
  FCreator := Application.Name;
  FPrintScaling := False;
  FFitWindow := False;
  FHideMenubar := False;
  FCenterWindow := False;
  FHideWindowUI := False;
  FHideToolbar := False;
end;

class function TfrxPDFExport.GetDescription: String;
begin
  Result := frxResources.Get('PDFexport');
end;

function TfrxPDFExport.ShowModal: TModalResult;
var
  s: String;
begin
  if FTitle = '' then
    FTitle := Report.ReportOptions.Name;
  if not Assigned(Stream) then
  begin
    if Assigned(Report) then
      FOutline := Report.PreviewOptions.OutlineVisible
    else
      FOutline := True;
    with TfrxPDFExportDialog.Create(nil) do
    begin
      OpenCB.Visible := not SlaveExport;
      if OverwritePrompt then
        SaveDialog1.Options := SaveDialog1.Options + [ofOverwritePrompt];
      if SlaveExport then
        FOpenAfterExport := False;

      if (FileName = '') and (not SlaveExport) then
      begin
        s := ChangeFileExt(ExtractFileName(frxUnixPath2WinPath(Report.FileName)), SaveDialog1.DefaultExt);
        SaveDialog1.FileName := s;
      end
      else
        SaveDialog1.FileName := FileName;

      OpenCB.Checked := FOpenAfterExport;
      CompressedCB.Checked := FCompressed;
      EmbeddedCB.Checked := FEmbedded;
      PrintOptCB.Checked := FPrintOpt;
      OutlineCB.Checked := FOutline;
      OutlineCB.Enabled := FOutline;
      BackgrCB.Checked := FBackground;

      if PageNumbers <> '' then
      begin
        PageNumbersE.Text := PageNumbers;
        PageNumbersRB.Checked := True;
      end;

      OwnPassE.Text := String(FOwnerPassword);
      UserPassE.Text := String(FUserPassword);
      PrintCB.Checked := ePrint in FProtectionFlags;
      CopyCB.Checked := eCopy in FProtectionFlags;
      ModCB.Checked := eModify in FProtectionFlags;
      AnnotCB.Checked := eAnnot in FProtectionFlags;

      TitleE.Text := FTitle;
      AuthorE.Text := FAuthor;
      SubjectE.Text := FSubject;
      KeywordsE.Text := FKeywords;
      CreatorE.Text := FCreator;
      ProducerE.Text := FProducer;

      PrintScalingCB.Checked := FPrintScaling;
      FitWindowCB.Checked := FFitWindow;
      HideMenubarCB.Checked := FHideMenubar;
      CenterWindowCB.Checked := FCenterWindow;
      HideWindowUICB.Checked := FHideWindowUI;
      HideToolbarCB.Checked := FHideToolbar;

      Result := ShowModal;
      if Result = mrOk then
      begin
        FOwnerPassword := AnsiString(OwnPassE.Text);
        FUserPassword := AnsiString(UserPassE.Text);
        FProtectionFlags := [];
        if PrintCB.Checked then
          FProtectionFlags := FProtectionFlags + [ePrint];
        if CopyCB.Checked then
          FProtectionFlags := FProtectionFlags + [eCopy];
        if ModCB.Checked then
          FProtectionFlags := FProtectionFlags + [eModify];
        if AnnotCB.Checked then
          FProtectionFlags := FProtectionFlags + [eAnnot];
        PageNumbers := '';
        CurPage := False;
        if CurPageRB.Checked then
          CurPage := True
        else if PageNumbersRB.Checked then
          PageNumbers := PageNumbersE.Text;

        FOpenAfterExport := OpenCB.Checked;
        FCompressed := CompressedCB.Checked;
        FEmbedded := EmbeddedCB.Checked;
        FPrintOpt := PrintOptCB.Checked;
        FOutline := OutlineCB.Checked;
        FBackground := BackgrCB.Checked;

        FTitle := TitleE.Text;
        FAuthor := AuthorE.Text;
        FSubject := SubjectE.Text;
        FKeywords := KeywordsE.Text;
        FCreator := CreatorE.Text;
        FProducer := ProducerE.Text;

        FPrintScaling := PrintScalingCB.Checked;
        FFitWindow := FitWindowCB.Checked;
        FHideMenubar := HideMenubarCB.Checked;
        FCenterWindow := CenterWindowCB.Checked;
        FHideWindowUI := HideWindowUICB.Checked;
        FHideToolbar := HideToolbarCB.Checked;

        if not SlaveExport then
        begin
          if DefaultPath <> '' then
            SaveDialog1.InitialDir := DefaultPath;
          if SaveDialog1.Execute then
            FileName := SaveDialog1.FileName
          else
            Result := mrCancel;
        end;
      end;
      Free;
    end;
  end else
    Result := mrOk;
end;

function TfrxPDFExport.Start: Boolean;
var
  f: Boolean;
begin
  if SlaveExport then
  begin
    if Report.FileName <> '' then
      FileName := ChangeFileExt(GetTemporaryFolder + ExtractFileName(Report.FileName), frxGet(8708))
    else
      FileName := ChangeFileExt(GetTempFile, frxGet(8708))
  end;
  if (FileName <> '') or Assigned(Stream) then
  begin
    if (ExtractFilePath(FileName) = '') and (DefaultPath <> '') then
      FileName := DefaultPath + '\' + FileName;
    f := Report.PreviewPages.Count > 200;
    FPDF := TfrxPDFFile.Create(UseFileCache and f, Report.EngineOptions.TempDir);
    FPDF.Compressed := FCompressed;
    FPDF.EmbeddedFonts := FEmbedded;
    FPDF.PrintOptimized := FPrintOpt;
    FPDF.Outline := FOutline;
    FPDF.Background := FBackground;
    FPDF.Author := FAuthor;
    FPDF.Subject := FSubject;
    FPDF.Creator := FCreator;
    FPDF.Producer := FProducer;
    FPDF.Keywords := FKeywords;

    FPDF.PrintScaling := FPrintScaling;
    FPDF.FitWindow := FFitWindow;
    FPDF.HideMenubar := FHideMenubar;
    FPDF.CenterWindow := FCenterWindow;
    FPDF.HideWindowUI := FHideWindowUI;
    FPDF.HideToolbar := FHideToolbar;

    FPDF.HTMLTags := FTags;
    FPDF.PageNumbers := PageNumbers;
    FPDF.TotalPages := Report.PreviewPages.Count;
    if FOutline then
      FPDF.PreviewOutline := Report.PreviewPages.Outline;
    FPDF.Protection := (FOwnerPassword <> '') or (FUserPassword <> '');
    FPDF.OwnerPassword := FOwnerPassword;
    FPDF.UserPassword := FUserPassword;
    FPDF.ProtectionFlags := FProtectionFlags;
    FPDF.Start;
    Result := True
  end else
    Result := False;
end;

procedure TfrxPDFExport.StartPage(Page: TfrxReportPage; Index: Integer);
begin
  FPDFPage := FPDF.AddPage(Page);
end;

procedure TfrxPDFExport.ExportObject(Obj: TfrxComponent);
begin
  if (Obj is TfrxView) and (ExportNotPrintable or TfrxView(Obj).Printable) then
    FPDFPage.AddObject(TfrxView(Obj));
end;

procedure TfrxPDFExport.Finish;
var
  Exp: TStream;
begin
  try
    try
      if Assigned(Stream) then
        Exp := Stream
      else
        Exp := TFileStream.Create(FileName, fmCreate);
      try
        FPDF.Title := FTitle;
        FPDF.SaveToStream(Exp);
      finally
        if not Assigned(Stream) then
          Exp.Free;
        if FOpenAfterExport and (not Assigned(Stream)) then
          ShellExecute(GetDesktopWindow, 'open', PChar(FileName), nil, nil, SW_SHOW);
      end;
    except
      on e: Exception do
        case Report.EngineOptions.NewSilentMode of
          simSilent:        Report.Errors.Add(e.Message);
          simMessageBoxes:  frxErrorMsg(e.Message);
          simReThrow:       raise;
        end;
    end;
  finally
    FPDF.Free;
  end;
end;

{ TfrxPDFExportDialog }

procedure TfrxPDFExportDialog.FormCreate(Sender: TObject);
begin
  Caption := frxGet(8700);
  OkB.Caption := frxGet(1);
  CancelB.Caption := frxGet(2);
  GroupPageRange.Caption := frxGet(7);
  AllRB.Caption := frxGet(3);
  CurPageRB.Caption := frxGet(4);
  PageNumbersRB.Caption := frxGet(5);
  DescrL.Caption := frxGet(9);
  GroupQuality.Caption := frxGet(8);
  CompressedCB.Caption := frxGet(8701);
  EmbeddedCB.Caption := frxGet(8702);
  PrintOptCB.Caption := frxGet(8703);
  OutlineCB.Caption := frxGet(8704);
  BackgrCB.Caption := frxGet(8705);
  OpenCB.Caption := frxGet(8706);
  SaveDialog1.Filter := frxGet(8707);
  SaveDialog1.DefaultExt := frxGet(8708);

  ExportPage.Caption := frxGet(107);
  DocInfoGB.Caption := frxGet(8971);
  InfoPage.Caption := frxGet(8972);
  TitleL.Caption := frxGet(8973);
  AuthorL.Caption := frxGet(8974);
  SubjectL.Caption := frxGet(8975);
  KeywordsL.Caption := frxGet(8976);
  CreatorL.Caption := frxGet(8977);
  ProducerL.Caption := frxGet(8978);

  SecurityPage.Caption := frxGet(8962);
  SecGB.Caption := frxGet(8979);
  PermGB.Caption := frxGet(8980);
  OwnPassL.Caption := frxGet(8964);
  UserPassL.Caption := frxGet(8965);
  PrintCB.Caption := frxGet(8966);
  ModCB.Caption := frxGet(8967);
  CopyCB.Caption := frxGet(8968);
  AnnotCB.Caption := frxGet(8969);

  ViewerPage.Caption := frxGet(8981);
  ViewerGB.Caption := frxGet(8982);
  HideToolbarCB.Caption := frxGet(8983);
  HideMenubarCB.Caption := frxGet(8984);
  HideWindowUICB.Caption := frxGet(8985);
  FitWindowCB.Caption := frxGet(8986);
  CenterWindowCB.Caption := frxGet(8987);
  PrintScalingCB.Caption := frxGet(8988);

  if UseRightToLeftAlignment then
    FlipChildren(True);
end;

procedure TfrxPDFExportDialog.PageNumbersEChange(Sender: TObject);
begin
  PageNumbersRB.Checked := True;
end;

procedure TfrxPDFExportDialog.PageNumbersEKeyPress(Sender: TObject;
  var Key: Char);
begin
  case key of
    '0'..'9':;
    #8, '-', ',':;
  else
    key := #0;
  end;
end;

procedure TfrxPDFExportDialog.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_F1 then
    frxResources.Help(Self);
end;

end.
