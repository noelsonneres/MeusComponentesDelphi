
{******************************************}
{                                          }
{             FastReport v6.0              }
{     Open Document Format export dialog   }
{                                          }
{         Copyright (c) 1998-2017          }
{          by Alexander Fediachov,         }
{             Fast Reports Inc.            }
{                                          }
{******************************************}

unit frxExportODFDialog;

interface

{$I frx.inc}

uses
{$IFNDEF FPC}
  Windows, Messages,
{$ENDIF}
  SysUtils, Classes,
  Graphics, Controls, Forms, Dialogs,
  StdCtrls, extctrls, frxExportBaseDialog, Variants,
  ComCtrls
{$IFDEF DELPHI16}
, System.UITypes
{$ENDIF};

type
  TfrxODFExportDialog = class(TfrxBaseExportDialog)
    WCB: TCheckBox;
    ContinuousCB: TCheckBox;
    PageBreaksCB: TCheckBox;
    BackgrCB: TCheckBox;
  protected
    procedure InitControlsFromFilter(ExportFilter: TfrxBaseDialogExportFilter); override;
    procedure InitFilterFromDialog(ExportFilter: TfrxBaseDialogExportFilter); override;
  end;

implementation

uses
  frxRes,
  frxrcExports,
  frxExportODF;

{$IFNDEF FPC}
{$R *.dfm}
{$ELSE}
{$R *.lfm}
{$ENDIF}

{ TfrxODFExportDialog }

procedure TfrxODFExportDialog.InitControlsFromFilter(
  ExportFilter: TfrxBaseDialogExportFilter);
begin
  inherited;
  with TfrxODFExport(ExportFilter) do
  begin
    ContinuousCB.Checked := SingleSheet;
    PageBreaksCB.Checked := ExportPageBreaks;
    WCB.Checked := Wysiwyg;
    BackgrCB.Checked := Background;
  end;
end;

procedure TfrxODFExportDialog.InitFilterFromDialog(
  ExportFilter: TfrxBaseDialogExportFilter);
begin
  inherited;
  with TfrxODFExport(ExportFilter) do
  begin
    ExportPageBreaks := PageBreaksCB.Checked;
    SingleSheet := ContinuousCB.Checked;
    Wysiwyg := WCB.Checked;
    Background := BackgrCB.Checked;
    CreationTime := Now;
  end;
end;

end.
