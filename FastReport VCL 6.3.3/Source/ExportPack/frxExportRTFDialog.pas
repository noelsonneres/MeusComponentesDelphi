
{******************************************}
{                                          }
{             FastReport v6.0              }
{         RTF export filter dialog         }
{                                          }
{         Copyright (c) 1998-2017          }
{          by Alexander Fediachov,         }
{             Fast Reports Inc.            }
{                                          }
{******************************************}

unit frxExportRTFDialog;

interface

{$I frx.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, extctrls, Variants, ComCtrls, frxExportBaseDialog
{$IFDEF DELPHI16}
, System.UITypes
{$ENDIF}
;

type
  TfrxRTFExportDialog = class(TfrxBaseExportDialog)
    WCB: TCheckBox;
    PageBreaksCB: TCheckBox;
    PicturesCB: TCheckBox;
    ContinuousCB: TCheckBox;
    HeadFootL: TLabel;
    PColontitulCB: TComboBox;
  protected
    procedure InitDialog; override;
    procedure InitControlsFromFilter(ExportFilter: TfrxBaseDialogExportFilter); override;
    procedure InitFilterFromDialog(ExportFilter: TfrxBaseDialogExportFilter); override;
  end;

implementation

uses frxRes, frxrcExports, frxExportRTF;

{$R *.dfm}

{ TfrxRTFExportDialog }

procedure TfrxRTFExportDialog.InitControlsFromFilter(
  ExportFilter: TfrxBaseDialogExportFilter);
begin
  SendMessage(GetWindow(PColontitulCB.Handle,GW_CHILD), EM_SETREADONLY, 1, 0);
  with TfrxRTFExport(ExportFilter) do
  begin
    ContinuousCB.Checked := SuppressPageHeadersFooters;
    PicturesCB.Checked := ExportPictures;
    PageBreaksCB.Checked := ExportPageBreaks;
    WCB.Checked := Wysiwyg;
    if HeaderFooterMode = hfText then
      PColontitulCB.ItemIndex := 0
    else if HeaderFooterMode = hfPrint then
      PColontitulCB.ItemIndex := 1
    else
      PColontitulCB.ItemIndex := 2;
  end;
  inherited;
end;

procedure TfrxRTFExportDialog.InitDialog;
begin
  inherited;
  PColontitulCB.Items[0] := frxGet(8952);
  PColontitulCB.Items[1] := frxGet(8953);
  PColontitulCB.Items[2] := frxGet(8954);
end;

procedure TfrxRTFExportDialog.InitFilterFromDialog(
  ExportFilter: TfrxBaseDialogExportFilter);
begin
  inherited;
  with TfrxRTFExport(ExportFilter) do
  begin
    if PColontitulCB.ItemIndex = 0 then
      HeaderFooterMode := hfText
    else if PColontitulCB.ItemIndex = 1 then
      HeaderFooterMode := hfPrint
    else
      HeaderFooterMode := hfNone;
    SuppressPageHeadersFooters := ContinuousCB.Checked;

    if HeaderFooterMode = hfPrint then
      SuppressPageHeadersFooters := True;

    ExportPictures := PicturesCB.Checked;
    ExportPageBreaks := PageBreaksCB.Checked;
    Wysiwyg := WCB.Checked;
  end;
end;

end.
