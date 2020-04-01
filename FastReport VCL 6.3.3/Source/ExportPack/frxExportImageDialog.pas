
{******************************************}
{                                          }
{             FastReport v5.0              }
{          Picture Export Filters          }
{                                          }
{         Copyright (c) 1998-2011          }
{          by Alexander Fediachov,         }
{             Fast Reports Inc.            }
{                                          }
{******************************************}

unit frxExportImageDialog;

interface

{$I frx.inc}

uses
{$IFNDEF FPC}
  Windows, Messages,
{$ELSE}
{$ENDIF}
  SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, frxExportBaseDialog, ComCtrls
{$IFDEF Delphi6}
  , Variants
{$ENDIF};

type
  TfrxIMGExportDialog = class(TfrxBaseExportDialog)
    CropPage: TCheckBox;
    Label2: TLabel;
    Quality: TEdit;
    Mono: TCheckBox;
    Label1: TLabel;
    Resolution: TEdit;
    SeparateCB: TCheckBox;
  private
    FFilter: TfrxBaseDialogExportFilter;
    procedure SetFilter(const Value: TfrxBaseDialogExportFilter);
  protected
    procedure InitControlsFromFilter(ExportFilter: TfrxBaseDialogExportFilter); override;
    procedure InitFilterFromDialog(ExportFilter: TfrxBaseDialogExportFilter); override;
  public
    property Filter: TfrxBaseDialogExportFilter read FFilter write SetFilter;
  end;

implementation

uses
  frxRes, frxrcExports, frxExportImage;

{$IFNDEF FPC}
{$R *.dfm}
{$ELSE}
{$R *.lfm}
{$ENDIF}

{ TfrxIMGExportDialog }

procedure TfrxIMGExportDialog.InitControlsFromFilter(
  ExportFilter: TfrxBaseDialogExportFilter);
begin
  inherited;
  with TfrxCustomImageExport(ExportFilter) do
  begin
    Filter := TfrxCustomImageExport(ExportFilter);
    Quality.Text := IntToStr(JPEGQuality);
    CropPage.Checked := CropImages;
    Mono.Checked := Monochrome;
    Quality.Enabled := ExportFilter is TfrxJPEGExport;
    Mono.Enabled := {$IFNDEF FPC}not (ExportFilter is TfrxGIFExport){$ELSE}True{$ENDIF};
    Self.Resolution.Text := IntToStr(Resolution);
    if SlaveExport then
    begin
      SeparateCB.Checked := False;
      SeparateCB.Visible := False;
    end
    else
      SeparateCB.Checked := SeparateFiles;
  end;
end;

procedure TfrxIMGExportDialog.InitFilterFromDialog(
  ExportFilter: TfrxBaseDialogExportFilter);
begin
  inherited;
  with TfrxCustomImageExport(ExportFilter) do
  begin
    JPEGQuality := StrToInt(Quality.Text);
    CropImages := CropPage.Checked;
    Monochrome := Mono.Checked;
    Resolution := StrToInt(Self.Resolution.Text);
    SeparateFiles := SeparateCB.Checked;
  end;
end;

procedure TfrxIMGExportDialog.SetFilter(const Value: TfrxBaseDialogExportFilter);
begin
  FFilter := Value;
//  SaveDialog1.Filter := FFilter.FilterDesc;
//  SaveDialog1.DefaultExt := FFilter.DefaultExt;
end;

end.
