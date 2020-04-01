
{******************************************}
{                                          }
{             FastReport v5.0              }
{             Map Layer Tags               }
{                                          }
{        Copyright (c) 2016 - 2017         }
{             by Oleg Adibekov             }
{             Fast Reports Inc.            }
{                                          }
{******************************************}

unit frxMapLayerTags;

{$I frx.inc}

interface

uses
  {$IFNDEF FPC}
  Windows, Messages,
  {$ELSE}
  LCLType, LCLIntf, LCLProc,
  {$ENDIF}
  SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, frxMapHelpers;

type
  TMapLayerTagsForm = class(TForm)
    CancelB: TButton;
    OkB: TButton;
    FileTagsLabel: TLabel;
    LayerTagsListBox: TListBox;
    LayerTagsLabel: TLabel;
    FilterLabel: TLabel;
    FilterEdit: TEdit;
    LayerAddButton: TButton;
    LayerDeleteButton: TButton;
    FileTagsListView: TListView;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FileTagsListViewColumnClick(Sender: TObject; Column: TListColumn);
    procedure LayerAddButtonClick(Sender: TObject);
    procedure LayerDeleteButtonClick(Sender: TObject);
    procedure FilterEditKeyPress(Sender: TObject; var Key: Char);
    procedure FilterEditChange(Sender: TObject);
  protected
    FSumTags: TfrxSumStringList;
    FTagId: Integer;

    procedure FillFileTags;
    function IsInLayerTags(st: String): Boolean;
    function IsEditFilter(st: String): Boolean;
  public
    { Public declarations }
  end;

function EditLayerTags(FileTags: TfrxSumStringList; LayerTags: TStringList;
                       Owner: TComponent = nil): boolean;

implementation

{$IFNDEF FPC}
{$R *.dfm}
{$ELSE}
{$R *.lfm}
{$ENDIF}

uses
  Math,
  frxDsgnIntf, frxMapLayer, frxRes;

function EditLayerTags(FileTags: TfrxSumStringList; LayerTags: TStringList;
                       Owner: TComponent = nil): boolean;
begin
  Result := False;
  if (FileTags <> nil) and (FileTags.Count > 0) then
    with TMapLayerTagsForm.Create(Owner) do
    begin
      LayerTagsListBox.Items.Text := LayerTags.Text;
      FSumTags := FileTags;
      FillFileTags;

      Result := ShowModal = mrOk;
      if LayerTags.Text <> LayerTagsListBox.Items.Text then
        LayerTags.Text := LayerTagsListBox.Items.Text;
      Free;
    end;
end;

type
  TfrxMapLayerTagsProperty = class(TfrxClassProperty)
  public
    function GetAttributes: TfrxPropertyAttributes; override;
    function Edit: Boolean; override;
  end;

{ TMapLayerTagsForm }

procedure TMapLayerTagsForm.FileTagsListViewColumnClick(Sender: TObject;
  Column: TListColumn);
begin
  if Column.ID = FTagID then
    FSumTags.Sorted := True
  else
    FSumTags.SortSum;

  FillFileTags;
end;

procedure TMapLayerTagsForm.FillFileTags;
var
  i: Integer;
begin
  FileTagsListView.Items.BeginUpdate;
  FileTagsListView.Items.Clear;
  for i := 0 to FSumTags.Count - 1 do
    if not IsInLayerTags(FSumTags[i]) and
           IsEditFilter(FSumTags[i]) then
      with FileTagsListView.Items.Add do
      begin
        Caption := FSumTags[i];
        SubItems.Add(IntToStr(FSumTags.Sum[i]));
      end;
  FileTagsListView.Items.EndUpdate;
end;

procedure TMapLayerTagsForm.FilterEditChange(Sender: TObject);
begin
  FillFileTags;
end;

procedure TMapLayerTagsForm.FilterEditKeyPress(Sender: TObject; var Key: Char);
begin
  // http://wiki.openstreetmap.org/wiki/Any_tags_you_like
  if      Key > #255 then
    Key := #0
  else if AnsiChar(Key) in ['A'..'Z'] then
    Key := AnsiLowerCase(Key)[1]
  else if not (AnsiChar(Key) in ['a'..'z', '0'..'9', '_', ':', #8]) then
    Key := #0;
end;

procedure TMapLayerTagsForm.FormCreate(Sender: TObject);
begin
  Translate(Self);

  with FileTagsListView do
  begin
    ViewStyle := vsReport;
    with Columns.Add do
    begin
      Alignment := taLeftJustify;
      Caption := frxResources.Get('ltTag');
      Width := Round(FileTagsListView.ClientWidth * 0.6);
      FTagId := ID;
    end;
    with Columns.Add do
    begin
      Alignment := taRightJustify;
      Caption := frxResources.Get('ltAmount');
      Width := Round(FileTagsListView.ClientWidth * 0.25);
    end;
  end;

  LayerTagsListBox.Sorted := True;

  FilterEdit.Text := '';
  FilterEdit.OnChange := FilterEditChange;
end;

procedure TMapLayerTagsForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_F1 then
    frxResources.Help(Self);
end;

function TMapLayerTagsForm.IsEditFilter(st: String): Boolean;
begin
  Result := (FilterEdit.Text = '') or (Pos(FilterEdit.Text, AnsiLowerCase(st)) > 0);
end;

function TMapLayerTagsForm.IsInLayerTags(st: String): Boolean;
begin
  Result := LayerTagsListBox.Items.IndexOf(st) <> -1;
end;

procedure TMapLayerTagsForm.LayerAddButtonClick(Sender: TObject);
var
  i, LastSelected, DelCount, NewSelected: Integer;
begin
  if FileTagsListView.SelCount < 1 then
    Exit;

  LastSelected := 0;
  LayerTagsListBox.Items.BeginUpdate;
  for i := 0 to FileTagsListView.Items.Count - 1 do
    if FileTagsListView.Items[i].Selected then
    begin
      LastSelected := i;
      LayerTagsListBox.AddItem(FileTagsListView.Items[i].Caption, nil);
    end;
  LayerTagsListBox.Items.EndUpdate;

  DelCount := FileTagsListView.SelCount;
{$IFNDEF FPC}
  FileTagsListView.DeleteSelected;
{$ELSE}
  i := 0;
  while i < FileTagsListView.Items.Count do
  begin
    if FileTagsListView.Items[i].Selected then
      FileTagsListView.Items[i].Delete
    else
      Inc(i);
  end;
{$ENDIF}
  NewSelected := Min(LastSelected - DelCount + 1, FileTagsListView.Items.Count - 1);
  if FileTagsListView.Items.Count > 0 then
    FileTagsListView.Items[NewSelected].Selected := True;
end;

procedure TMapLayerTagsForm.LayerDeleteButtonClick(Sender: TObject);
var
  i, LastSelected, DelCount, NewSelected: Integer;
begin
  if LayerTagsListBox.SelCount < 1 then
    Exit;

  LastSelected := 0;
  for i := 0 to LayerTagsListBox.Count - 1 do
    if LayerTagsListBox.Selected[i] then
      LastSelected := i;

  DelCount := LayerTagsListBox.SelCount;
  LayerTagsListBox.DeleteSelected;
  NewSelected := Min(LastSelected - DelCount + 1, LayerTagsListBox.Count - 1);
  if LayerTagsListBox.Count > 0 then
    LayerTagsListBox.Selected[NewSelected] := True;

  FillFileTags;
end;

{ TfrxMapLayerTagsProperty }

function TfrxMapLayerTagsProperty.Edit: Boolean;
var
  MapFileLayer: TfrxMapFileLayer;
begin
  MapFileLayer := TfrxMapFileLayer(Component);

  Result := EditLayerTags(MapFileLayer.FileTags, MapFileLayer.LayerTags{, Designer});
  if Result then
    MapFileLayer.ReRead;
end;

function TfrxMapLayerTagsProperty.GetAttributes: TfrxPropertyAttributes;
begin
  Result := [paDialog, paReadOnly];
end;

initialization

  frxPropertyEditors.Register(TypeInfo(TStringList), TfrxMapFileLayer, 'LayerTags',
    TfrxMapLayerTagsProperty);

end.
