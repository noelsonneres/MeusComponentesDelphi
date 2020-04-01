{******************************************}
{                                          }
{             FastReport v6.0              }
{            PDF export filter             }
{                                          }
{         Copyright (c) 1998-2019          }
{          by Alexander Fediachov,         }
{             Fast Reports Inc.            }
{                                          }
{******************************************}
{      haBlock alignment improved by:      }
{              Nikolay Zverev              }
{            www.delphinotes.ru            }
{******************************************}

unit frxExportPDFDialog;

interface

{$I frx.inc}

uses
  Windows, SysUtils, Graphics, Controls, Classes, Forms, Dialogs, frxExportBaseDialog,
  StdCtrls, ExtCtrls, ComCtrls, Variants, frxPreview;

type
  TfrxPDFExportDialog = class(TfrxBaseExportDialog)
    InfoPage: TTabSheet;
    SecurityPage: TTabSheet;
    ViewerPage: TTabSheet;
    CompressedCB: TCheckBox;
    EmbeddedCB: TCheckBox;
    PrintOptCB: TCheckBox;
    OutlineCB: TCheckBox;
    BackgrCB: TCheckBox;
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
    QualityEdit: TEdit;
    Label2: TLabel;
    TransparentCB: TCheckBox;
    PDFStandardComboBox: TComboBox;
    PDFStandardLabel: TLabel;
    PDFVersionComboBox: TComboBox;
    PDFVersionLabel: TLabel;
    procedure PDFStandardComboBoxChange(Sender: TObject);
  protected
    procedure SetupComboBox(ComboBox: TComboBox; st: String);
    procedure DoStandard;

    procedure InitDialog; override;
    procedure InitControlsFromFilter(ExportFilter: TfrxBaseDialogExportFilter); override;
    procedure InitFilterFromDialog(ExportFilter: TfrxBaseDialogExportFilter); override;
  end;

implementation

uses frxRes, frxrcExports, frxExportPDF, frxExportPDFHelpers;

{$R *.dfm}

{ TfrxPDFExportDialog }

procedure TfrxPDFExportDialog.DoStandard;
var
  PDFStandard: TPDFStandard;
  pv: TPDFVersion;
  IsPDFA, IsPDFA_1: Boolean;
begin
  PDFStandard := PDFStandardByName(PDFStandardComboBox.Text);
  IsPDFA := frxExportPDFHelpers.IsPDFA(PDFStandard);
  IsPDFA_1:= frxExportPDFHelpers.IsPDFA_1(PDFStandard);

  if IsVersionByStandard(PDFStandard, pv) then
    SetupComboBox(PDFVersionComboBox, PDFVersionName[pv]);
  PDFVersionComboBox.Enabled := PDFStandard = psNone;

  SecGB.Visible := not IsPDFA;
  PermGB.Visible := not IsPDFA;

  if IsPDFA then
    EmbeddedCB.Checked := True;
  EmbeddedCB.Enabled := not IsPDFA;

  if IsPDFA_1 then
    TransparentCB.Checked := False;
  TransparentCB.Enabled := not IsPDFA_1;
end;

procedure TfrxPDFExportDialog.InitControlsFromFilter(ExportFilter: TfrxBaseDialogExportFilter);
var
  PDFFilter: TfrxPDFExport;
begin
  inherited;
  PDFFilter := TfrxPDFExport(ExportFilter);

  with PDFFilter do
  begin
    if      Report = nil then
      Outline := True
    else if Report.Preview = nil then
      Outline := Report.PreviewOptions.OutlineVisible
    else
      Outline := TfrxPreview(Report.Preview).OutlineVisible;

    SetupComboBox(PDFStandardComboBox, PDFStandardName[PDFStandard]);
    DoStandard;
    if not IsPDFA then
      SetupComboBox(PDFVersionComboBox, PDFVersionName[PDFVersion]);

    CompressedCB.Checked := Compressed;
    EmbeddedCB.Checked := EmbeddedFonts;
    PrintOptCB.Checked := PrintOptimized;
    OutlineCB.Checked := Outline;
    OutlineCB.Enabled := Outline;
    BackgrCB.Checked := Background;
    QualityEdit.Text := IntToStr(Quality);

    OwnPassE.Text := String(OwnerPassword);
    UserPassE.Text := String(UserPassword);
    PrintCB.Checked := ePrint in ProtectionFlags;
    CopyCB.Checked := eCopy in ProtectionFlags;
    ModCB.Checked := eModify in ProtectionFlags;
    AnnotCB.Checked := eAnnot in ProtectionFlags;

    TitleE.Text := Title;
    AuthorE.Text := Author;
    SubjectE.Text := Subject;
    KeywordsE.Text := Keywords;
    CreatorE.Text := Creator;
    ProducerE.Text := Producer;

    PrintScalingCB.Checked := PrintScaling;
    FitWindowCB.Checked := FitWindow;
    HideMenubarCB.Checked := HideMenubar;
    CenterWindowCB.Checked := CenterWindow;
    HideWindowUICB.Checked := HideWindowUI;
    HideToolbarCB.Checked := HideToolbar;
    TransparentCB.Checked := Transparency;
  end;
end;

procedure TfrxPDFExportDialog.InitDialog;
var
  ps: TPDFStandard;
  pv: TPDFVersion;
begin
  inherited InitDialog;

  with PDFStandardComboBox.Items do
  begin
    Clear;
    BeginUpdate;
    for ps := Low(TPDFStandard) to High(TPDFStandard) do
      Add(PDFStandardName[ps]);
    EndUpdate;
  end;

  with PDFVersionComboBox.Items do
  begin
    Clear;
    BeginUpdate;
    for pv := Low(TPDFVersion) to High(TPDFVersion) do
      Add(PDFVersionName[pv]);
    EndUpdate;
  end;
end;

procedure TfrxPDFExportDialog.InitFilterFromDialog(
  ExportFilter: TfrxBaseDialogExportFilter);
var
  PDFFilter: TfrxPDFExport;
  pFlags: TfrxPDFEncBits;
begin
  inherited;
  PDFFilter := TfrxPDFExport(ExportFilter);
  with PDFFilter do
  begin
    OwnerPassword := AnsiString(OwnPassE.Text);
    UserPassword := AnsiString(UserPassE.Text);
    pFlags := [];
    if PrintCB.Checked then
      pFlags := pFlags + [ePrint];
    if CopyCB.Checked then
      pFlags := pFlags + [eCopy];
    if ModCB.Checked then
      pFlags := pFlags + [eModify];
    if AnnotCB.Checked then
      pFlags := pFlags + [eAnnot];
    ProtectionFlags := pFlags;

    PDFStandard := PDFStandardByName(PDFStandardComboBox.Text);
    PDFVersion := PDFVersionByName(PDFVersionComboBox.Text);

    Compressed := CompressedCB.Checked;
    EmbeddedFonts := EmbeddedCB.Checked;
    PrintOptimized := PrintOptCB.Checked;
    Outline := OutlineCB.Checked;
    Background := BackgrCB.Checked;
    Quality := StrToInt(QualityEdit.Text);

    Title := TitleE.Text;
    Author := AuthorE.Text;
    Subject := SubjectE.Text;
    Keywords := KeywordsE.Text;
    Creator := CreatorE.Text;
    Producer := ProducerE.Text;

    PrintScaling := PrintScalingCB.Checked;
    FitWindow := FitWindowCB.Checked;
    HideMenubar := HideMenubarCB.Checked;
    CenterWindow := CenterWindowCB.Checked;
    HideWindowUI := HideWindowUICB.Checked;
    HideToolbar := HideToolbarCB.Checked;
    Transparency := TransparentCB.Checked;
  end;
end;

procedure TfrxPDFExportDialog.PDFStandardComboBoxChange(Sender: TObject);
begin
  inherited;
  DoStandard;
end;

procedure TfrxPDFExportDialog.SetupComboBox(ComboBox: TComboBox; st: String);
var
  i: Integer;
begin
  with ComboBox do
    for i := 0 to Items.Count - 1 do
      if st = Items[i] then
      begin
        ItemIndex := i;
        Break;
      end;
end;

end.
