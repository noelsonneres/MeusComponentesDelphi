{******************************************}
{                                          }
{             FastReport v6.0              }
{           Base export dialog             }
{                                          }
{         Copyright (c) 1998-2018          }
{             Fast Reports Inc.            }
{                                          }
{******************************************}

unit frxExportBaseDialog;

interface

{$I frx.inc}

uses
{$IFNDEF FPC}
  Windows,
{$ELSE}
  LCLType, LCLIntf, LCLProc,
{$ENDIF}
  SysUtils, Graphics, Controls, Classes, Forms, Dialogs,
  StdCtrls, ExtCtrls, {ComObj,} frxClass,
  ComCtrls, Variants;

type
  TfrxBaseExportDialog = class;

  TfrxBaseExportDialogClass = class of TfrxBaseExportDialog;

  TfrxBaseDialogExportFilter = class(TfrxCustomExportFilter)
  protected
    procedure AfterFinish; override;
  public
    function ShowModal: TModalResult; override;
    class function ExportDialogClass: TfrxBaseExportDialogClass; virtual;
  end;

  TfrxBaseExportDialog = class(TForm)
    PageControl1: TPageControl;
    ExportPage: TTabSheet;
    OkB: TButton;
    CancelB: TButton;
    OpenCB: TCheckBox;
    GroupQuality: TGroupBox;
    GroupPageRange: TGroupBox;
    DescrL: TLabel;
    AllRB: TRadioButton;
    CurPageRB: TRadioButton;
    PageNumbersRB: TRadioButton;
    PageNumbersE: TEdit;
    FiltersNameCB: TComboBox;
    GroupBox1: TGroupBox;
    procedure FormCreate(Sender: TObject);
    procedure PageNumbersEChange(Sender: TObject);
    procedure PageNumbersEKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure OkBClick(Sender: TObject);
  protected
    procedure InitDialog; virtual;
    procedure InitControlsFromFilter(ExportFilter: TfrxBaseDialogExportFilter); virtual;
    procedure InitFilterFromDialog(ExportFilter: TfrxBaseDialogExportFilter); virtual;
  end;

implementation

uses
  frxRes, frxIOTransportIntf, frxUtils
{$IFNDEF FPC}
  ,ShellAPI
{$ENDIF};

{$IFNDEF FPC}
{$R *.dfm}
{$ELSE}
{$R *.lfm}
{$ENDIF}

{ TfrxPDFExportDialog }

procedure TfrxBaseExportDialog.FormCreate(Sender: TObject);
begin
  InitDialog;
end;

procedure TfrxBaseExportDialog.PageNumbersEChange(Sender: TObject);
begin
  PageNumbersRB.Checked := True;
end;

procedure TfrxBaseExportDialog.PageNumbersEKeyPress(Sender: TObject;
  var Key: Char);
begin
  case key of
    '0'..'9':;
    #8, '-', ',':;
  else
    key := #0;
  end;
end;

procedure TfrxBaseExportDialog.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_F1 then
    frxResources.Help(Self);
end;

procedure TfrxBaseExportDialog.InitControlsFromFilter(
  ExportFilter: TfrxBaseDialogExportFilter);
var
  ItemIndex: Integer;
begin
      OpenCB.Visible := not ExportFilter.SlaveExport;

      if ExportFilter.SlaveExport then
      begin
        OpenCB.Enabled := False;
        OpenCB.State := cbGrayed;
        ExportFilter.OpenAfterExport := False;
        //OpenCB.Checked := ExportFilter.OpenAfterExport;
      end;
      OpenCB.Checked := ExportFilter.OpenAfterExport;
      FiltersNameCB.Enabled := not ExportFilter.SlaveExport;
      FiltersNameCB.Visible := (FiltersNameCB.Items.Count > 1);
      GroupBox1.Visible := FiltersNameCB.Visible;

      //else
      //  SaveDialog1.FileName := FileName;

      if ExportFilter.PageNumbers <> '' then
      begin
        PageNumbersE.Text := ExportFilter.PageNumbers;
        PageNumbersRB.Checked := True;
      end;

      FiltersNameCB.ItemIndex := 0;
      ItemIndex := FiltersNameCB.ItemIndex;
      if ExportFilter.IOTransport <> nil then
        ItemIndex := FiltersNameCB.Items.IndexOfObject(ExportFilter.IOTransport);

      //if ItemIndex = -1 then
      //  ItemIndex := FiltersNameCB.Items.AddObject(IOTransport.GetDescription, IOTransport);
      if (ItemIndex <> -1) and not ExportFilter.SlaveExport then
        ExportFilter.DefaultIOTransport := TfrxCustomIOTransport(FiltersNameCB.Items.Objects[ItemIndex]).CreateFilterClone(fvExport);
      ExportFilter.DefaultIOTransport.InitFromExport(ExportFilter);
      if (ExportFilter.FileName = '') and (not ExportFilter.SlaveExport) then
      begin
        ExportFilter.FileName := ChangeFileExt(ExtractFileName(frxUnixPath2WinPath(ExportFilter.Report.FileName)), ExportFilter.DefaultIOTransport.DefaultExt);
        //SaveDialog1.FileName := s;
      end;

end;

procedure TfrxBaseExportDialog.InitDialog;

  function GetStr(const Id: string): string;
  begin
    Result := frxResources.Get(Id)
  end;

  procedure AssignTexts(Root: TControl);
  var
    i: Integer;
  begin
    with Root do
    begin
      if Tag > 0 then
        SetTextBuf(PChar(GetStr(IntToStr(Tag))));

      if Root is TWinControl then
        with Root as TWinControl do
          for i := 0 to ControlCount - 1 do
            if Controls[i] is TControl then
              AssignTexts(Controls[i] as TControl);
    end;
  end;
var
  Control: TControl;
begin
  AssignTexts(Self);
  ExportPage.Caption := frxGet(107);
  FillItemsList(FiltersNameCB.Items, fvExport);

  if PageControl1.PageCount = 1 then
  begin
    while PageControl1.Pages[0].ControlCount > 0 do
    begin
      Control := PageControl1.Pages[0].Controls[0];
      Control.Parent := Self;
      Control.Top := Control.Top + PageControl1.Top;
      Control.Left := Control.Left + PageControl1.Left + PageControl1.Pages[0].Left;
    end;
    PageControl1.Visible := False;
  end;

  if UseRightToLeftAlignment then
    FlipChildren(True);
end;

procedure TfrxBaseExportDialog.InitFilterFromDialog(
  ExportFilter: TfrxBaseDialogExportFilter);
var
  ItemIndex: Integer;
begin
  //FiltersNameCB.ItemIndex := 0;
  ItemIndex := FiltersNameCB.ItemIndex;
  if ExportFilter.IOTransport <> nil then
    ItemIndex := FiltersNameCB.Items.IndexOfObject(ExportFilter.IOTransport);
  if (ItemIndex <> -1) and not ExportFilter.SlaveExport then
    ExportFilter.DefaultIOTransport :=
      TfrxCustomIOTransport(FiltersNameCB.Items.Objects[FiltersNameCB.ItemIndex])
      .CreateFilterClone(fvExport);

  ExportFilter.PageNumbers := '';
  ExportFilter.CurPage := False;
  if CurPageRB.Checked then
    ExportFilter.CurPage := True
  else if PageNumbersRB.Checked then
    ExportFilter.PageNumbers := PageNumbersE.Text;

  ExportFilter.OpenAfterExport := OpenCB.Checked;
end;

procedure TfrxBaseExportDialog.OkBClick(Sender: TObject);
begin

end;

{ TfrxBaseDialogExportFilter }

procedure TfrxBaseDialogExportFilter.AfterFinish;
begin
  if OpenAfterExport and (not Assigned(Stream)) then
{$IFNDEF FPC}
    ShellExecute(GetDesktopWindow, 'open', PChar(FileName), nil, nil, SW_SHOW);
{$ELSE}
    OpenDocument(FileName);
{$ENDIF}
end;

class function TfrxBaseDialogExportFilter.ExportDialogClass: TfrxBaseExportDialogClass;
begin
  Result := TfrxBaseExportDialog;
end;

function TfrxBaseDialogExportFilter.ShowModal: TModalResult;
var
  eDialog: TfrxBaseExportDialog;
begin
  if not Assigned(Stream) then
  begin
    eDialog := TfrxBaseExportDialog(ExportDialogClass.NewInstance);
    eDialog.Create(nil);
    eDialog.InitControlsFromFilter(Self);

      Result := eDialog.ShowModal;
      if Result = mrOk then
        eDialog.InitFilterFromDialog(Self);
     eDialog.Free;
  end
  else
    Result := mrOk;
end;



end.
