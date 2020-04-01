
{******************************************}
{                                          }
{             FastReport v6.0              }
{         Simple text export dialog        }
{                                          }
{         Copyright (c) 1998-2017          }
{          by Alexander Fediachov,         }
{             Fast Reports Inc.            }
{                                          }
{******************************************}

unit frxExportTextDialog;

interface

{$I frx.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, extctrls, frxExportBaseDialog,
  ComCtrls
{$IFDEF Delphi6}, Variants {$ENDIF};

type
  TfrxSimpleTextExportDialog = class(TfrxBaseExportDialog)
    PageBreaksCB: TCheckBox;
    FramesCB: TCheckBox;
    EmptyLinesCB: TCheckBox;
    OEMCB: TCheckBox;
  protected
    procedure InitControlsFromFilter(ExportFilter: TfrxBaseDialogExportFilter); override;
    procedure InitFilterFromDialog(ExportFilter: TfrxBaseDialogExportFilter); override;
  end;

implementation

uses frxRes, frxrcExports, frxExportText;

{$R *.dfm}

{ TfrxSimpleTextExportDialog }

procedure TfrxSimpleTextExportDialog.InitControlsFromFilter(
  ExportFilter: TfrxBaseDialogExportFilter);
begin
  inherited;
  with TfrxSimpleTextExport(ExportFilter) do
  begin
    PageBreaksCB.Checked := PageBreaks;
    FramesCB.Checked := Frames;
    EmptyLinesCB.Checked := EmptyLines;
    OEMCB.Checked := OEMCodepage;
  end;
end;

procedure TfrxSimpleTextExportDialog.InitFilterFromDialog(
  ExportFilter: TfrxBaseDialogExportFilter);
begin
  inherited;
  with TfrxSimpleTextExport(ExportFilter) do
  begin
    PageBreaks := PageBreaksCB.Checked;
    OpenAfterExport := OpenCB.Checked;
    Frames := FramesCB.Checked;
    EmptyLines := EmptyLinesCB.Checked;
    OEMCodepage := OEMCB.Checked;
  end;
end;

end.
