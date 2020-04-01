
{******************************************}
{                                          }
{             FastReport v6.0              }
{            XLS export dialog             }
{                                          }
{         Copyright (c) 1998-2017          }
{             Fast Reports Inc.            }
{                                          }
{******************************************}
{$I frx.inc}
unit frxExportBIFFDialog;

interface

uses
  Windows, SysUtils, Classes,
  Forms,
  Dialogs,
  StdCtrls,
  ComCtrls,
  Controls,
  frxExportBaseDialog
{$IFDEF DELPHI16}
, System.UITypes
{$ENDIF}
;

type
  TfrxBIFFExportDialog = class(TfrxBaseExportDialog)
    rbOriginal: TRadioButton;
    rbSingle: TRadioButton;
    rbChunks: TRadioButton;
    edChunk: TEdit;
    tsInfo: TTabSheet;
    lbTitle: TLabel;
    edTitle: TEdit;
    lbAuthor: TLabel;
    edAuthor: TEdit;
    lbKeywords: TLabel;
    edKeywords: TEdit;
    lbRevision: TLabel;
    edRevision: TEdit;
    lbAppName: TLabel;
    edAppName: TEdit;
    lbSubject: TLabel;
    edSubject: TEdit;
    lbCategory: TLabel;
    edCategory: TEdit;
    lbCompany: TLabel;
    edCompany: TEdit;
    lbManager: TLabel;
    edManager: TEdit;
    lbComment: TLabel;
    edComment: TMemo;
    tsProt: TTabSheet;
    lbPass: TLabel;
    edPass1: TEdit;
    lbPassInfo: TLabel;
    lbPassConf: TLabel;
    edPass2: TEdit;
    cbAutoCreateFile: TCheckBox;
    TabSheet1: TTabSheet;
    cbPreciseQuality: TCheckBox;
    cbPictures: TCheckBox;
    cbGridLines: TCheckBox;
    cbFit: TCheckBox;
    cbDelEmptyRows: TCheckBox;
    cbFormulas: TCheckBox;
  protected
    procedure InitControlsFromFilter(ExportFilter: TfrxBaseDialogExportFilter); override;
    procedure InitFilterFromDialog(ExportFilter: TfrxBaseDialogExportFilter); override;
  end;

implementation

uses
  frxRes, frxExportBIFF, frxUtils;

const
  GoodQuality: Extended = 2.0;
  DraftQuality: Extended = 10.0;

{$R *.dfm}

{ TfrxBIFFExportDialog }
procedure TfrxBIFFExportDialog.InitControlsFromFilter(
  ExportFilter: TfrxBaseDialogExportFilter);

  procedure st(c: TControl; const s: AnsiString);
  begin
    c.SetTextBuf(PChar(string(s)));
  end;

begin
  inherited;
  with TfrxBIFFExport(ExportFilter) do
  begin
    if SlaveExport then
    begin
      OpenCB.Enabled    := False;
      OpenCB.State      := cbGrayed;
    end;

    cbGridLines.Checked       := GridLines;
    cbPreciseQuality.Checked  := Inaccuracy <= GoodQuality;
    rbOriginal.Checked        := not SingleSheet and (ChunkSize = 0);
    rbSingle.Checked          := SingleSheet;
    rbChunks.Checked          := ChunkSize > 0;
    edChunk.Text              := '50';
    cbFit.Checked             := FitPages;
    cbPictures.Checked        := Pictures;
    cbDelEmptyRows.Checked    := DeleteEmptyRows;
    cbFormulas.Checked        := ExportFormulas;

    st(edTitle,     Title);
    st(edAuthor,    Author);
    st(edKeywords,  Keywords);
    st(edRevision,  Revision);
    st(edAppName,   AppName);
    st(edSubject,   Subject);
    st(edCategory,  Category);
    st(edCompany,   Company);
    st(edManager,   Manager);
    st(edComment,   Comment);
    st(edPass1,     '');
    st(edPass2,     '');
  end;
end;

procedure TfrxBIFFExportDialog.InitFilterFromDialog(
  ExportFilter: TfrxBaseDialogExportFilter);
begin
  inherited;
  with TfrxBIFFExport(ExportFilter) do
  begin
    if edPass1.Text <> edPass2.Text then
      MessageDlg(frxGet(9179), mtError, [mbOk], 0)
    else
    begin
      GridLines := cbGridLines.Checked;
      SingleSheet := rbSingle.Checked;
      FitPages := cbFit.Checked;
      Pictures := cbPictures.Checked;
      DeleteEmptyRows := cbDelEmptyRows.Checked;
      ExportFormulas := cbFormulas.Checked;

      Title := AnsiString(edTitle.Text);
      Author := AnsiString(edAuthor.Text);
      Keywords := AnsiString(edKeywords.Text);
      Revision := AnsiString(edRevision.Text);
      AppName := AnsiString(edAppName.Text);
      Subject := AnsiString(edSubject.Text);
      Category := AnsiString(edCategory.Text);
      Company := AnsiString(edCompany.Text);
      Manager := AnsiString(edManager.Text);
      Comment := AnsiString(edComment.Text);

      Password := edPass1.Text;

      try
        if rbChunks.Checked then
          ChunkSize := StrToInt(edChunk.Text)
        else
          ChunkSize := 0;

        if ChunkSize < 0 then
          ChunkSize := 0;
      except
        ChunkSize := 0;
      end;

      if cbPreciseQuality.Checked then
        Inaccuracy := GoodQuality
      else
        Inaccuracy := DraftQuality;

      if not SlaveExport and cbAutoCreateFile.Checked then
        FileName := GetTempFile + DefaultExt
    end;
  end;
end;

end.

