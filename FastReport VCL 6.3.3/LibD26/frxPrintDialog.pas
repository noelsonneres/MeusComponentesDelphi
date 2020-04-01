
{******************************************}
{                                          }
{             FastReport v5.0              }
{              Print dialog                }
{                                          }
{         Copyright (c) 1998-2014          }
{         by Alexander Tzyganenko,         }
{            Fast Reports Inc.             }
{                                          }
{******************************************}

unit frxPrintDialog;

interface

{$I frx.inc}

uses
  {$IFNDEF FPC}
  Windows, Messages,
  {$ENDIF}
  SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons, ComCtrls, frxClass
  {$IFDEF FPC}
  , LResources, LCLType, LCLIntf, LazHelper
  {$ELSE}
  , ImgList, frxCtrls
  {$ENDIF}
{$IFDEF Delphi6}
, Variants
{$ENDIF};


type
  TfrxPrintDialog = class(TForm)
    OkB: TButton;
    CancelB: TButton;
    FileDlg: TSaveDialog;
    Label12: TGroupBox;
    WhereL: TLabel;
    WhereL1: TLabel;
    PrintersCB: TComboBox;
    PropButton: TButton;
    FileCB: TCheckBox;
    Label1: TGroupBox;
    DescrL: TLabel;
    AllRB: TRadioButton;
    CurPageRB: TRadioButton;
    PageNumbersRB: TRadioButton;
    PageNumbersE: TEdit;
    Label2: TGroupBox;
    CopiesL: TLabel;
    CollateImg: TImage;
    NonCollateImg: TImage;
    CopiesPB: TPaintBox;
    CopiesE: TEdit;
    CollateCB: TCheckBox;
    UpDown1: TUpDown;
    ScaleGB: TGroupBox;
    PagPageSizeCB: TComboBox;
    NameL: TLabel;
    PagSizeL: TLabel;
    PrintModeCB: TComboBox;
    PrintModeIL: TImageList;
    OtherGB: TGroupBox;
    PrintL: TLabel;
    DuplexL: TLabel;
    PrintPagesCB: TComboBox;
    DuplexCB: TComboBox;
    OrderL: TLabel;
    OrderCB: TComboBox;
    procedure PrintersCBDrawItem(Control: TWinControl; Index: Integer;
      ARect: TRect; State: TOwnerDrawState);
    procedure FormCreate(Sender: TObject);
    procedure PropButtonClick(Sender: TObject);
    procedure PrintersCBClick(Sender: TObject);
    procedure PageNumbersRBClick(Sender: TObject);
    procedure CollateLClick(Sender: TObject);
    procedure CollateCBClick(Sender: TObject);
    procedure CopiesPBPaint(Sender: TObject);
    procedure PageNumbersEEnter(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure PrintModeCBDrawItem(Control: TWinControl; Index: Integer;
      ARect: TRect; State: TOwnerDrawState);
    procedure FormShow(Sender: TObject);
    procedure PrintModeCBClick(Sender: TObject);
  private
    { Private declarations }
    OldIndex: Integer;
  public
    { Public declarations }
    AReport: TfrxReport;
    ADuplexMode: TfrxDuplexMode;
  end;


implementation

{$IFNDEF FPC}
{$R *.DFM}
{$ELSE}
{$R *.lfm}
{$ENDIF}

uses frxPrinter, {$IFNDEF FPC}Printers, {$ENDIF }frxUtils, frxRes;


procedure TfrxPrintDialog.FormCreate(Sender: TObject);
begin
  Caption := frxGet(200);
  Label12.Caption := frxGet(201);
  DescrL.Caption := frxGet(9);
  Label1.Caption := frxGet(202);
  CopiesL.Caption := frxGet(203);
  CollateCB.Caption := frxGet(204);
  Label2.Caption := frxGet(205);
  PrintL.Caption := frxGet(206);
  WhereL.Caption := frxGet(208);
  OkB.Caption := frxGet(1);
  CancelB.Caption := frxGet(2);
  PropButton.Caption := frxGet(209);
  AllRB.Caption := frxGet(3);
  CurPageRB.Caption := frxGet(4);
  PageNumbersRB.Caption := frxGet(5);
  FileCB.Caption := frxGet(210);
  NameL.Caption := frxGet(212);
  ScaleGB.Caption := frxGet(213);
  PagSizeL.Caption := frxGet(214);
  DuplexL.Caption := frxGet(216);
  OtherGB.Caption := frxGet(207);
  OrderL.Caption := frxGet(211);
  FileDlg.Title := frxGet(507);
  FileDlg.Filter := frxGet(510);

  OrderCB.Items.Clear;
  OrderCB.Items.Add(frxResources.Get('poDirect'));
  OrderCB.Items.Add(frxResources.Get('poReverse'));

  PrintPagesCB.Items.Clear;
  PrintPagesCB.Items.Add(frxResources.Get('ppAll'));
  PrintPagesCB.Items.Add(frxResources.Get('ppOdd'));
  PrintPagesCB.Items.Add(frxResources.Get('ppEven'));
  PrintPagesCB.ItemIndex := 0;

  DuplexCB.Items.Clear;
  DuplexCB.Items.Add(frxResources.Get('dupDefault'));
  DuplexCB.Items.Add(frxResources.Get('dupVert'));
  DuplexCB.Items.Add(frxResources.Get('dupHorz'));
  DuplexCB.Items.Add(frxResources.Get('dupSimpl'));
  DuplexCB.ItemIndex := 0;

  PrintModeCB.Items.Clear;
  PrintModeCB.Items.Add(frxResources.Get('pmDefault'));
  PrintModeCB.Items.Add(frxResources.Get('pmSplit'));
  PrintModeCB.Items.Add(frxResources.Get('pmJoin'));
  PrintModeCB.Items.Add(frxResources.Get('pmScale'));
  {$IFNDEF FPC}
  SetWindowLong(CopiesE.Handle, GWL_STYLE, GetWindowLong(CopiesE.Handle, GWL_STYLE)
  {$IFNDEF FPC}or ES_NUMBER{$ENDIF});
  {$ENDIF}

  if Screen.PixelsPerInch > 96 then
    PrintersCB.ItemHeight := Round(16 * (Screen.PixelsPerInch / 96));
  PrintersCB.Items.Assign(frxPrinters.Printers);
  PrintersCB.ItemIndex := frxPrinters.PrinterIndex;
  PrintersCBClick(nil);

  OldIndex := frxPrinters.PrinterIndex;
  CollateCBClick(nil);

  if UseRightToLeftAlignment then
    FlipChildren(True);
  {$IFDEF DELPHI24}
    ScaleForPPI(Screen.PixelsPerInch);
  {$ENDIF}
end;

procedure TfrxPrintDialog.FormShow(Sender: TObject);
begin
  UpDown1.Position := AReport.PrintOptions.Copies;
  CollateCB.Checked := AReport.PrintOptions.Collate;
  PageNumbersE.Text := AReport.PrintOptions.PageNumbers;
  if AReport.PrintOptions.PageNumbers <> '' then
    PageNumbersRB.Checked := True;
  PrintPagesCB.ItemIndex := Integer(AReport.PrintOptions.PrintPages);
  if AReport.PrintOptions.Reverse then
    OrderCB.ItemIndex := 1
  else
    OrderCB.ItemIndex := 0;

  PrintModeCB.ItemIndex := Integer(AReport.PrintOptions.PrintMode);
  DuplexCB.ItemIndex := Integer(ADuplexMode);
  PrintModeCBClick(nil);
  if AReport.PrintOptions.PrintMode <> pmDefault then
  begin
    //PagPageSizeCB.ItemIndex := frxPrinters.Printer.PaperIndex(AReport.PrintOptions.PrintOnSheet) + 1;
    //if frxPrinters.Printer.PaperIndex(256) < frxPrinters.Printer.PaperIndex(AReport.PrintOptions.PrintOnSheet) then
    //  PagPageSizeCB.ItemIndex := PagPageSizeCB.ItemIndex - 1;
    if frxPrinters.Printer.PaperIndex(256) < frxPrinters.Printer.PaperIndex(AReport.PrintOptions.PrintOnSheet) then
      PagPageSizeCB.ItemIndex := frxPrinters.Printer.PaperIndex(AReport.PrintOptions.PrintOnSheet)
    else
      PagPageSizeCB.ItemIndex := frxPrinters.Printer.PaperIndex(AReport.PrintOptions.PrintOnSheet) + 1;
  end;
end;

procedure TfrxPrintDialog.FormHide(Sender: TObject);
begin
  if ModalResult <> mrOk then
    frxPrinters.PrinterIndex := OldIndex
  else
  begin
    frxPrinters.Printer.FileName := '';
    if FileCB.Checked then
      if FileDlg.Execute then
        frxPrinters.Printer.FileName := ChangeFileExt(FileDlg.FileName, '.prn') else
        ModalResult := mrCancel;
  end;

  if ModalResult = mrOk then
  begin
    if CopiesE.Text <> '' then
      AReport.PrintOptions.Copies := StrToInt(CopiesE.Text)
    else
      AReport.PrintOptions.Copies := 1;
    AReport.PrintOptions.Collate := CollateCB.Checked;
    if AllRB.Checked then
      AReport.PrintOptions.PageNumbers := ''
    else if CurPageRB.Checked then
      AReport.PrintOptions.PageNumbers := IntToStr(AReport.PreviewPages.CurPreviewPage)
    else
      AReport.PrintOptions.PageNumbers := PageNumbersE.Text;
    AReport.PrintOptions.PrintPages := TfrxPrintPages(PrintPagesCB.ItemIndex);
    ADuplexMode := TfrxDuplexMode(DuplexCB.ItemIndex);
    AReport.PrintOptions.Reverse := OrderCB.ItemIndex = 1;

    AReport.PrintOptions.PrintMode := TfrxPrintMode(PrintModeCB.ItemIndex);
    AReport.PrintOptions.PrintOnSheet := frxPrinters.Printer.PaperNameToNumber(PagPageSizeCB.Text);
  end;
end;

procedure TfrxPrintDialog.PrintersCBDrawItem(Control: TWinControl; Index: Integer;
  ARect: TRect; State: TOwnerDrawState);
begin
  with PrintersCB.Canvas do
  begin
    FillRect(ARect);
    frxResources.PreviewButtonImages.Draw(PrintersCB.Canvas, ARect.Left + 2, ARect.Top, 2);
    TextOut(ARect.Left + 24, ARect.Top + 1, PrintersCB.Items[Index]);
  end;
end;

procedure TfrxPrintDialog.PropButtonClick(Sender: TObject);
var
  dup: Integer;
begin
  {$IFDEF FPC}
    frxPrinters.PrinterIndex := PrintersCB.ItemIndex;
  {$ENDIF}
  frxPrinters.Printer.PropertiesDlg;
  dup := frxPrinters.Printer.Duplex - 1;
  if dup = 0 then dup := 3;

  if dup > 0 then
  begin
    ADuplexMode := TfrxDuplexMode(dup);
    DuplexCB.ItemIndex := dup;
  end;
end;

procedure TfrxPrintDialog.PrintersCBClick(Sender: TObject);
var
  SaveSheet: Integer;
begin
  if PagPageSizeCB.ItemIndex <= 0 then
    SaveSheet := -1
  else
    SaveSheet := frxPrinters.Printer.PaperNameToNumber(PagPageSizeCB.Text);

  frxPrinters.PrinterIndex := PrintersCB.ItemIndex;
  WhereL1.Caption := frxPrinters.Printer.Port;
  PagPageSizeCB.Items := frxPrinters.Printer.Papers;
  PagPageSizeCB.Items.Delete(frxPrinters.Printer.PaperIndex(256));
  PagPageSizeCB.Items.Insert(0, frxResources.Get('pgDefault'));

  if (SaveSheet <> -1) and (frxPrinters.Printer.PaperIndex(SaveSheet) <> -1) then
  begin
    //PagPageSizeCB.ItemIndex := frxPrinters.Printer.PaperIndex(SaveSheet) + 1;
    //if frxPrinters.Printer.PaperIndex(256) < frxPrinters.Printer.PaperIndex(SaveSheet) then
    //  PagPageSizeCB.ItemIndex := PagPageSizeCB.ItemIndex - 1
    if frxPrinters.Printer.PaperIndex(256) < frxPrinters.Printer.PaperIndex(SaveSheet) then
      PagPageSizeCB.ItemIndex := frxPrinters.Printer.PaperIndex(SaveSheet)
    else
      PagPageSizeCB.ItemIndex := frxPrinters.Printer.PaperIndex(SaveSheet) + 1;
  end
  else
    PagPageSizeCB.ItemIndex := 0
end;

procedure TfrxPrintDialog.PageNumbersEEnter(Sender: TObject);
begin
  PageNumbersRB.Checked := True;
end;

procedure TfrxPrintDialog.PageNumbersRBClick(Sender: TObject);
begin
  if Visible then
    PageNumbersE.SetFocus;
end;

procedure TfrxPrintDialog.CollateLClick(Sender: TObject);
begin
  CollateCB.Checked := not CollateCB.Checked;
end;

procedure TfrxPrintDialog.CollateCBClick(Sender: TObject);
begin
  CopiesPBPaint(nil);
end;

procedure TfrxPrintDialog.CopiesPBPaint(Sender: TObject);
begin
  with CopiesPB.Canvas do
  begin
    Brush.Color := Color;
    FillRect(Rect(0, 0, CopiesPB.Width, CopiesPB.Height));
    if CollateCB.Checked then
      frxDrawTransparent(CopiesPB.Canvas, 0, 0, CollateImg.Picture.Bitmap) else
      frxDrawTransparent(CopiesPB.Canvas, 0, 0, NonCollateImg.Picture.Bitmap);
  end;
end;

procedure TfrxPrintDialog.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_F1 then
    frxResources.Help(Self);
end;

procedure TfrxPrintDialog.PrintModeCBDrawItem(Control: TWinControl;
  Index: Integer; ARect: TRect; State: TOwnerDrawState);
begin
  with PrintModeCB do
  begin
    Canvas.FillRect(ARect);
    PrintModeIL.Draw(Canvas, ARect.Left + 2, ARect.Top + 1, Index);
    Canvas.TextOut(ARect.Left + 74, ARect.Top + 10, Items[Index]);
  end;
end;

procedure TfrxPrintDialog.PrintModeCBClick(Sender: TObject);
var
  DefaultMode: Boolean;
begin
  DefaultMode := PrintModeCB.ItemIndex = 0;
  if DefaultMode then
    PagPageSizeCB.ItemIndex := 0;
  PagPageSizeCB.Enabled := not DefaultMode;
  if not DefaultMode and (PagPageSizeCB.ItemIndex = 0) then
    PagPageSizeCB.ItemIndex := frxPrinters.Printer.PaperIndex(DMPAPER_A4);
end;

end.
