
{******************************************}
{                                          }
{             FastReport v5.0              }
{         Excel OLE export filter          }
{                                          }
{         Copyright (c) 1998-2014          }
{          by Alexander Fediachov,         }
{             Fast Reports Inc.            }
{                                          }
{******************************************}
{               Improved by:               }
{              Serge Buzadzhy              }
{             buzz@devrace.com             }
{              Bysoev Alexander            }
{             Kanal-B@Yandex.ru            }
{******************************************}

unit frxExportXLSDialog;

interface

{$I frx.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Printers, frxExportBaseDialog
{$IFDEF DELPHI16}
, System.UITypes, ComCtrls
{$ENDIF}
;

type
  TfrxXLSExportDialog = class(TfrxBaseExportDialog)
    MergeCB: TCheckBox;
    WCB: TCheckBox;
    ContinuousCB: TCheckBox;
    PicturesCB: TCheckBox;
    AsTextCB: TCheckBox;
    BackgrCB: TCheckBox;
    FastExpCB: TCheckBox;
    PageBreaksCB: TCheckBox;
    cbGrid: TCheckBox;
  protected
    procedure InitControlsFromFilter(ExportFilter: TfrxBaseDialogExportFilter); override;
    procedure InitFilterFromDialog(ExportFilter: TfrxBaseDialogExportFilter); override;
  end;


implementation

uses
  frxRes,
  {$IFDEF DBGLOG}frxDebug,{$ENDIF}
  frxrcExports,
  frxExportXLS;

{$R *.dfm}

{ TfrxXLSExportDialog }

procedure TfrxXLSExportDialog.InitControlsFromFilter(
  ExportFilter: TfrxBaseDialogExportFilter);
begin
  inherited;
  with TfrxXLSExport(ExportFilter) do
  begin
    ContinuousCB.Checked := (not EmptyLines) or SuppressPageHeadersFooters;
    PicturesCB.Checked := ExportPictures;
    MergeCB.Checked := MergeCells;
    WCB.Checked := Wysiwyg;
    AsTextCB.Checked := AsText;
    BackgrCB.Checked := Background;
    FastExpCB.Checked := FastExport;
    PageBreaksCB.Checked := pageBreaks;
    cbGrid.Checked := GridLines;
  end;
end;

procedure TfrxXLSExportDialog.InitFilterFromDialog(
  ExportFilter: TfrxBaseDialogExportFilter);
begin
  inherited;
  with TfrxXLSExport(ExportFilter) do
  begin
    MergeCells := MergeCB.Checked;
    PageBreaks :=  PageBreaksCB.Checked;
    ExportPictures := PicturesCB.Checked;
    EmptyLines := not ContinuousCB.Checked;
    SuppressPageHeadersFooters := ContinuousCB.Checked;
    Wysiwyg := WCB.Checked;
    AsText := AsTextCB.Checked;
    Background := BackgrCB.Checked;
    FastExport := FastExpCB.Checked;
    GridLines := cbGrid.Checked;
  end;
end;

end.

