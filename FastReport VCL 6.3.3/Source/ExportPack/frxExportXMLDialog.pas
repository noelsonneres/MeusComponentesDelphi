
{******************************************}
{                                          }
{             FastReport v6.0              }
{         XML Excel export dialog          }
{                                          }
{         Copyright (c) 1998-2016          }
{             Fast Reports Inc.            }
{                                          }
{******************************************}

unit frxExportXMLDialog;

interface

{$I frx.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, extctrls, frxExportBaseDialog, Variants, ComCtrls
{$IFDEF DELPHI16}
, System.UITypes
{$ENDIF}
;

type
  TfrxXMLExportDialog = class(TfrxBaseExportDialog)
    WCB: TCheckBox;
    ContinuousCB: TCheckBox;
    PageBreaksCB: TCheckBox;
    BackgrCB: TCheckBox;
    SplitToSheetGB: TGroupBox;
    RPagesRB: TRadioButton;
    PrintOnPrevRB: TRadioButton;
    RowsCountRB: TRadioButton;
    ERows: TEdit;
    NotSplitRB: TRadioButton;
    procedure ERowsKeyPress(Sender: TObject; var Key: Char);
    procedure ERowsChange(Sender: TObject);
  protected
    procedure InitControlsFromFilter(ExportFilter: TfrxBaseDialogExportFilter); override;
    procedure InitFilterFromDialog(ExportFilter: TfrxBaseDialogExportFilter); override;
  end;

implementation

uses frxRes, frxrcExports, frxExportXML;


{$R *.dfm}

{ TfrxXMLExportDialog }

procedure TfrxXMLExportDialog.InitControlsFromFilter(
  ExportFilter: TfrxBaseDialogExportFilter);
begin
  inherited;
  with TfrxXMLExport(ExportFilter) do
  begin
    ContinuousCB.Checked := (not EmptyLines) or SuppressPageHeadersFooters;
    PageBreaksCB.Checked := ExportPageBreaks and (not ContinuousCB.Checked);
    PrintOnPrevRB.Checked := (Split = ssPrintOnPrev);
    RPagesRB.Checked := (Split = ssRPages);
    NotSplitRB.Checked := (Split = ssNotSplit);
    if RowsCount <> 0 then
    begin
      ERows.Text := IntToStr(RowsCount);
      RowsCountRB.Checked := True;
    end;
    WCB.Checked := Wysiwyg;
    BackgrCB.Checked := Background;
  end;
end;

procedure TfrxXMLExportDialog.InitFilterFromDialog(
  ExportFilter: TfrxBaseDialogExportFilter);
begin
  inherited;
  with TfrxXMLExport(ExportFilter) do
  begin
    if RowsCountRB.Checked then
    begin
      Split := ssRowsCount;
      RowsCount := StrToInt(ERows.Text);
    end
    else if PrintOnPrevRB.Checked then
      Split := ssPrintOnPrev
    else if RPagesRB.Checked then
      Split := ssRPages
    else
      Split := ssNotSplit;

    ExportPageBreaks := PageBreaksCB.Checked and (not ContinuousCB.Checked);
    EmptyLines := not ContinuousCB.Checked;
    SuppressPageHeadersFooters := ContinuousCB.Checked;
    Wysiwyg := WCB.Checked;
    Background := BackgrCB.Checked;
  end;
end;

procedure TfrxXMLExportDialog.ERowsKeyPress(Sender: TObject;
  var Key: Char);
begin
  case key of
    '0'..'9', #8:;
  else
    key := #0;
  end;
end;

procedure TfrxXMLExportDialog.ERowsChange(Sender: TObject);
begin
  RowsCountRB.Checked := True;
end;

end.
