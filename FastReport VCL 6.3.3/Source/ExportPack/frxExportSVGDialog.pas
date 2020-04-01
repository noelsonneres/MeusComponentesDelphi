
{******************************************}
{                                          }
{             FastReport v5.0              }
{           SVG 1.1 Export dialog          }
{                                          }
{         Copyright (c) 1998-2017          }
{             by Oleg Adibekov             }
{             Fast Reports Inc.            }
{                                          }
{******************************************}

unit frxExportSVGDialog;

interface

{$I frx.inc}

uses
  Windows,
  Classes,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  StrUtils,
  Graphics,
  frxExportBaseDialog,
{$IFDEF DELPHI16}
  System.UITypes,
{$ENDIF}
{$IFDEF Delphi10}
  WideStrings,
{$ENDIF}
  ComCtrls;

type
  TfrxSVGExportDialog = class(TfrxBaseExportDialog)
    PicturesL: TLabel;
    StylesCB: TCheckBox;
    UnifiedPicturesCB: TCheckBox;
    PicturesCB: TCheckBox;
    MultipageCB: TCheckBox;
    PFormatCB: TComboBox;
    FormattedCB: TCheckBox;
    NavigationCB: TCheckBox;
  protected
    procedure InitControlsFromFilter(ExportFilter: TfrxBaseDialogExportFilter); override;
    procedure InitFilterFromDialog(ExportFilter: TfrxBaseDialogExportFilter); override;
  end;

implementation

uses frxRes, frxExportHelpers, frxExportSVG;

{$R *.dfm}

{ TfrxSVGExportDialog}

procedure TfrxSVGExportDialog.InitControlsFromFilter(
  ExportFilter: TfrxBaseDialogExportFilter);
  procedure DisableCB(CB: TCheckBox);
  begin
    CB.State := cbGrayed;
    CB.Enabled := False;
  end;
begin
  inherited;
  with TfrxSVGExport(ExportFilter) do
  begin
   if SlaveExport then
    begin
      EmbeddedCSS := True;
      DisableCB(StylesCB);

      EmbeddedPictures := True;
      DisableCB(PicturesCB);

      MultiPage := False;
      DisableCB(MultipageCB);

      Navigation := False;
      DisableCB(NavigationCB);

      PictureFormat := pfPNG;
      PFormatCB.Enabled := False;

      UnifiedPictures := True;
      DisableCB(UnifiedPicturesCB);
    end;

    StylesCB.Checked := EmbeddedCSS;
    PicturesCB.Checked := EmbeddedPictures;
    MultipageCB.Checked := MultiPage;
    NavigationCB.Checked := Navigation;
    UnifiedPicturesCB.Checked := UnifiedPictures;
    FormattedCB.Checked := Formatted;
    PFormatCB.ItemIndex := Integer(PictureFormat);
  end;
end;

procedure TfrxSVGExportDialog.InitFilterFromDialog(
  ExportFilter: TfrxBaseDialogExportFilter);
begin
  inherited;
  with TfrxSVGExport(ExportFilter) do
  begin
    EmbeddedCSS := StylesCB.Checked;
    EmbeddedPictures := PicturesCB.Checked;
    MultiPage := MultipageCB.Checked;
    Navigation := NavigationCB.Checked;
    UnifiedPictures := UnifiedPicturesCB.Checked;
    Formatted := FormattedCB.Checked;
    PictureFormat := TfrxPictureFormat(PFormatCB.ItemIndex);
  end;
end;

end.
