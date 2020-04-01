
{******************************************}
{                                          }
{             FastReport v6.0              }
{           XLSX export dialog             }
{                                          }
{         Copyright (c) 1998-2017          }
{             Fast Reports Inc.            }
{                                          }
{******************************************}

unit frxExportXLSXDialog;

interface

{$I frx.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, Types,
  StdCtrls, ExtCtrls, ComCtrls, frxExportBaseDialog
{$IFDEF DELPHI16}
, System.UITypes
{$ENDIF}
;

type
  TfrxXLSXExportDialog = class(TfrxBaseExportDialog)
    ContinuousCB: TCheckBox;
    SplitToSheetGB: TGroupBox;
    RPagesRB: TRadioButton;
    NotSplitRB: TRadioButton;
    RowsCountRB: TRadioButton;
    edChunk: TEdit;
    PageBreaksCB: TCheckBox;
    WCB: TCheckBox;
    DataOnlyCB: TCheckBox;
  protected
    procedure InitControlsFromFilter(ExportFilter: TfrxBaseDialogExportFilter); override;
    procedure InitFilterFromDialog(ExportFilter: TfrxBaseDialogExportFilter); override;
  end;

implementation

uses
  frxRes, frxrcExports, frxExportXLSX;

{$R *.dfm}

{ TfrxXLSXExportDialog }

procedure TfrxXLSXExportDialog.InitControlsFromFilter(
  ExportFilter: TfrxBaseDialogExportFilter);
begin
  inherited;
  with TfrxXLSXExport(ExportFilter) do
  begin
    NotSplitRB.Checked := SingleSheet;
    RPagesRB.Checked := not SingleSheet and (ChunkSize = 0);
    RowsCountRB.Checked := ChunkSize > 0;
    edChunk.Text := IntToStr(ChunkSize);
    WCB.Checked := Wysiwyg;
    ContinuousCB.Checked := not EmptyLines;
    PageBreaksCB.Checked := ExportPageBreaks;
    DataOnlyCB.Checked := DataOnly;
  end;
end;

procedure TfrxXLSXExportDialog.InitFilterFromDialog(
  ExportFilter: TfrxBaseDialogExportFilter);
begin
  with TfrxXLSXExport(ExportFilter) do
  begin
    Wysiwyg := WCB.Checked;
    EmptyLines := not ContinuousCB.Checked;
    ExportPageBreaks := PageBreaksCB.Checked and (not ContinuousCB.Checked);
    SingleSheet := NotSplitRB.Checked;
    DataOnly := DataOnlyCB.Checked;
    if RowsCountRB.Checked then
      try
        ChunkSize := StrToInt(edChunk.Text);
      except
        ChunkSize := 0;
      end;
  end;
  inherited;
end;

end.
