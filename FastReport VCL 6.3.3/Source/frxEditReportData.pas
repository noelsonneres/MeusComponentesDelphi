
{******************************************}
{                                          }
{             FastReport v5.0              }
{         Report datasets selector         }
{                                          }
{         Copyright (c) 1998-2014          }
{         by Alexander Tzyganenko,         }
{            Fast Reports Inc.             }
{                                          }
{******************************************}

unit frxEditReportData;

interface

{$I frx.inc}

uses
  {$IFNDEF FPC}
  Windows, Messages,
  {$ENDIF}
  SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, frxClass, CheckLst
  {$IFDEF FPC}
  , LCLType
  {$ENDIF}
{$IFDEF Delphi6}
, Variants
{$ENDIF};


type
  TfrxReportDataForm = class(TForm)
    OKB: TButton;
    CancelB: TButton;
    DatasetsLB: TCheckListBox;
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DatasetsLBClickCheck(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    FStandalone: Boolean;
    procedure BuildConnectionList;
    procedure BuildDatasetList;
  public
    Report: TfrxReport;
  end;


implementation

{$IFDEF FPC}
{$R *.lfm}
{$ELSE}
{$R *.DFM}
{$ENDIF}

uses frxDesgn, frxRes
  {$IFNDEF FPC} , frxUtils ,IniFiles , Registry{$ENDIF};

var
  PrevWidth: Integer = 0;
  PrevHeight: Integer = 0;

procedure TfrxReportDataForm.FormCreate(Sender: TObject);
begin
  FStandalone := (frxDesignerComp <> nil) and frxDesignerComp.Standalone;
  if FStandalone then
    Caption := frxGet(5800)
  else
    Caption := frxGet(2800);
  OKB.Caption := frxGet(1);
  CancelB.Caption := frxGet(2);

  if UseRightToLeftAlignment then
    FlipChildren(True);
  {$IFDEF DELPHI24}
    ScaleForPPI(Screen.PixelsPerInch);
  {$ENDIF}
end;

procedure TfrxReportDataForm.FormShow(Sender: TObject);
begin
  if PrevWidth <> 0 then
  begin
    Width := PrevWidth;
    Height := PrevHeight;
  end;

  DatasetsLB.SetBounds(4, 4, ClientWidth - 8, ClientHeight - OkB.Height - 12);
  OkB.Left := ClientWidth - OkB.Width - CancelB.Width - 8;
  CancelB.Left := ClientWidth - CancelB.Width - 4;
  OkB.Top := ClientHeight - OkB.Height - 4;
  CancelB.Top := OkB.Top;

  if FStandalone then
    BuildConnectionList
  else
    BuildDatasetList;
end;

procedure TfrxReportDataForm.FormHide(Sender: TObject);
var
  i: Integer;
begin
  PrevWidth := Width;
  PrevHeight := Height;
  if ModalResult <> mrOk then Exit;

  if FStandalone then
    Report.ReportOptions.ConnectionName := ''
  else
    Report.Datasets.Clear;

  for i := 0 to DatasetsLB.Items.Count - 1 do
    if DatasetsLB.Checked[i] then
      if FStandalone then
        Report.ReportOptions.ConnectionName := DatasetsLB.Items[i]
      else
        Report.DataSets.Add(TfrxDataSet(DatasetsLB.Items.Objects[i]));
end;

procedure TfrxReportDataForm.BuildConnectionList;
{$IFNDEF FPC}
var
  i: Integer;
  ini: TRegistry;
  sl: TStringList;
  s2: TStringList;
{$ENDIF}
begin
  {$IFNDEF FPC}
  ini := TRegistry.Create;
  try
    sl := TStringList.Create;
    s2 := TStringList.Create;
    try
      ini.RootKey := HKEY_LOCAL_MACHINE;
      if ini.OpenKeyReadOnly(DEF_REG_CONNECTIONS)  then
      begin
        ini.GetValueNames(sl);
        ini.CloseKey;
      end;

      ini.RootKey := HKEY_CURRENT_USER;
      if ini.OpenKeyReadOnly(DEF_REG_CONNECTIONS)  then
      begin
        ini.GetValueNames(s2);
        ini.CloseKey;
      end;

      sl.AddStrings(s2);

      for i := 0 to sl.Count - 1 do
      begin
        DataSetsLB.Items.Add(sl[i]);
        DataSetsLB.Checked[i] := CompareText(sl[i], Report.ReportOptions.ConnectionName) = 0;
      end;
    finally
      sl.Free;
      s2.Free;
    end;
  finally
    ini.Free;
  end;
  {$ENDIF}
end;

procedure TfrxReportDataForm.BuildDatasetList;
var
  i: Integer;
  ds: TfrxDataSet;
  dsList: TStringList;
begin
  dsList := TStringList.Create;

  if Report.EnabledDataSets.Count > 0 then
  begin
    for i := 0 to Report.EnabledDataSets.Count - 1 do
    begin
      ds := Report.EnabledDataSets[i].DataSet;
      if ds <> nil then
        dsList.AddObject(ds.UserName, ds);
    end;
  end
  else
    Report.GetActiveDataSetList(dsList);

  dsList.Sort;

  for i := 0 to dsList.Count - 1 do
  begin
    ds := TfrxDataSet(dsList.Objects[i]);
    if (csDesigning in Report.ComponentState) and
      ((ds.Owner is TForm) or (ds.Owner is TDataModule){$IFDEF Delphi5} or (ds.Owner is TFrame){$ENDIF}) then
      DataSetsLB.Items.AddObject(ds.UserName + '  (' + ds.Owner.Name + '.' + ds.Name + ')', ds)
    else
    begin
      if not (ds.Owner is TfrxReport) or (ds.Owner = Report) then
        DataSetsLB.Items.AddObject(ds.UserName, ds);
    end;
    if Report.Datasets.Find(ds) <> nil then
      DataSetsLB.Checked[DataSetsLB.Items.Count - 1] := True;
  end;

  dsList.Free;
end;

procedure TfrxReportDataForm.DatasetsLBClickCheck(Sender: TObject);
var
  i: Integer;
begin
  if FStandalone then
    for i := 0 to DatasetsLB.Items.Count - 1 do
      if i <> DatasetsLB.ItemIndex then
        DatasetsLB.Checked[i] := False;
end;

procedure TfrxReportDataForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_F1 then
    frxResources.Help(Self);
end;

end.
