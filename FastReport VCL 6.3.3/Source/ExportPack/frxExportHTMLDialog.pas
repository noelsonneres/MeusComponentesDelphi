
{******************************************}
{                                          }
{             FastReport v6.0              }
{     HTML table export filter dialog      }
{                                          }
{         Copyright (c) 1998-2017          }
{             Fast Reports Inc.            }
{                                          }
{******************************************}

unit frxExportHTMLDialog;

interface

{$I frx.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Variants, frxExportBaseDialog, ComCtrls
{$IFDEF DELPHI16}
, System.UITypes
{$ENDIF}
;

type
  TfrxHTMLExportDialog = class(TfrxBaseExportDialog)
    StylesCB: TCheckBox;
    PicsSameCB: TCheckBox;
    FixWidthCB: TCheckBox;
    NavigatorCB: TCheckBox;
    MultipageCB: TCheckBox;
    BackgrCB: TCheckBox;
    PicturesL: TLabel;
    PFormatCB: TComboBox;
  protected
    procedure InitDialog; override;
    procedure InitControlsFromFilter(ExportFilter: TfrxBaseDialogExportFilter); override;
    procedure InitFilterFromDialog(ExportFilter: TfrxBaseDialogExportFilter); override;
  end;


implementation

uses frxRes, frxrcExports, frxExportHTML, frxImageConverter;

{$R *.dfm}

{ TfrxHTMLExportDialog }

procedure TfrxHTMLExportDialog.InitControlsFromFilter(
  ExportFilter: TfrxBaseDialogExportFilter);
begin
  inherited;
  SendMessage(GetWindow(PFormatCB.Handle,GW_CHILD), EM_SETREADONLY, 1, 0);
  with TfrxHTMLExport(ExportFilter) do
  begin

      MultipageCB.Enabled := not SlaveExport;
      BackgrCB.Enabled := not SlaveExport;
      NavigatorCB.Enabled := not SlaveExport;
      PicsSameCB.Enabled := not SlaveExport;

      if SlaveExport then
      begin
        ExportPictures := True;
        PicsInSameFolder := True;
        Navigator := False;
        Multipage := False;
        Background := False;
      end;

//      if (FileName = '') and (not SlaveExport) then
//        SaveDialog1.FileName := ChangeFileExt(ExtractFileName(frxUnixPath2WinPath(Report.FileName)), SaveDialog1.DefaultExt)
//      else
//        SaveDialog1.FileName := FileName;

      StylesCB.Checked := ExportStyles;
      PicsSameCB.Checked := PicsInSameFolder;

      if not ExportPictures then
        PFormatCB.ItemIndex := 0
      else
        case PictureType of
          gpBMP: PFormatCB.ItemIndex := 2;
          gpJPG: PFormatCB.ItemIndex := 1;
          gpGIF: PFormatCB.ItemIndex := 3;
          else   PFormatCB.ItemIndex := 1;
        end;

      FixWidthCB.Checked := FixedWidth;
      NavigatorCB.Checked := Navigator;
      MultipageCB.Checked := Multipage;
      BackgrCB.Checked := Background;
  end;
end;

procedure TfrxHTMLExportDialog.InitDialog;
begin
  PFormatCB.Items[0] := frxGet(8313);
  inherited;
end;

procedure TfrxHTMLExportDialog.InitFilterFromDialog(
  ExportFilter: TfrxBaseDialogExportFilter);
begin
  inherited;
  with TfrxHTMLExport(ExportFilter) do
  begin
    ExportStyles := StylesCB.Checked;
    PicsInSameFolder := PicsSameCB.Checked;
    ExportPictures := PFormatCB.ItemIndex > 0;

    case PFormatCB.ItemIndex of
      1:
        PictureType := gpJPG;
      2:
        PictureType := gpBMP;
      3:
        PictureType := gpGIF;
    else
      PictureType := gpPNG;
    end;

    FixedWidth := FixWidthCB.Checked;
    Multipage := MultipageCB.Checked;
    Navigator := NavigatorCB.Checked;
    Background := BackgrCB.Checked;
  end;
end;

end.
