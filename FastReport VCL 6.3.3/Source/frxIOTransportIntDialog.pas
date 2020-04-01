
{******************************************}
{                                          }
{             FastReport v6.0              }
{            Save Filter Dialog            }
{                                          }
{          Copyright (c) 2016-2017         }
{             by Oleg Adibekov,            }
{             Fast Reports Inc.            }
{                                          }
{******************************************}

unit frxIOTransportIntDialog;

interface

{$I frx.inc}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Buttons, ExtCtrls;

type
  TDirChangeEvent = procedure(Name, Id: String; DirItems: TStrings) of object;
  TDirCreateEvent = procedure(Name: String; DirItems: TStrings) of object;
  TDirDeleteEvent = TDirChangeEvent;
  TFileDeleteEvent = TDirChangeEvent;

  TfrxIOInternetDialogMode = (idmOpen, idmSave, idmDir);

  TfrxIOTransportDialogIntForm = class(TForm)
    CancelB: TButton;
    OkB: TButton;
    FileNameEdit: TEdit;
    FileNameLabel: TLabel;
    CreateDirectoryButton: TButton;
    DeleteButton: TButton;
    DirectoryLV: TListView;
    ListSB: TSpeedButton;
    IconsSB: TSpeedButton;
    FillTimer: TTimer;
    UpdateP: TPanel;
    UpdateL: TLabel;
    RefreshSB: TSpeedButton;
    procedure DirectoryListBoxDblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    function GetFileName: String;
    procedure CreateDirectoryButtonClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure DeleteButtonClick(Sender: TObject);
    procedure IconsSBClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FillTimerTimer(Sender: TObject);
    procedure DirectoryLVClick(Sender: TObject);
  private
    FItemsList: TStrings;
    FOnDirChange: TDirChangeEvent;
    FOnDirCreate: TDirCreateEvent;
    FOnDirDelete: TDirDeleteEvent;
    FOnFileDelete: TFileDeleteEvent;
    FDialogMode: TfrxIOInternetDialogMode;
    FIOTransport: TComponent;

    function GetItems: TStrings;
    procedure UpdateListView;
    procedure SetFileName(const Value: String);
    function IsConfirm(const Text: String): boolean;
    procedure ListChanged(Sender: TObject);
    procedure StartUpdate;
    procedure EndUpdate;
    procedure SetDialogMode(const Value: TfrxIOInternetDialogMode);
  protected
    function IsDirectory(Index: Integer): Boolean;
    function IsFile(Index: Integer): Boolean;
    function StripDir(Index: Integer): String;
    function IdOf(Index: Integer): String;
  public
    class function AsFile(fName: String): String;
    class function AsDirectory(fName: String): String;
    procedure DisableDelete;

    property OnDirChange: TDirChangeEvent read FOnDirChange write FOnDirChange;
    property OnDirCreate: TDirCreateEvent read FOnDirCreate write FOnDirCreate;
    property OnDirDelete: TDirDeleteEvent read FOnDirDelete write FOnDirDelete;
    property OnFileDelete: TFileDeleteEvent read FOnFileDelete write FOnFileDelete;
    property DirItems: TStrings read GetItems;
    property DialogMode: TfrxIOInternetDialogMode read FDialogMode write SetDialogMode;
    property DialogFileName: String read GetFileName write SetFileName;
    property IOTransport: TComponent read FIOTransport write FIOTransport;
  end;

implementation

{$R *.dfm}

uses
  frxMapHelpers, frxUtils, frxIOTransportHelpers, frxRes;

{ TfrxIOTransportDialogIntForm }

class function TfrxIOTransportDialogIntForm.AsDirectory(fName: String): String;
begin
  Result := '[' + fName + ']';
end;

class function TfrxIOTransportDialogIntForm.AsFile(fName: String): String;
begin
  Result := fName;
end;

procedure TfrxIOTransportDialogIntForm.DeleteButtonClick(Sender: TObject);
begin
  with DirectoryLV do
    if ItemIndex >= 0 then
      if      IsDirectory(ItemIndex) and
              Assigned(OnDirDelete) and
              IsConfirm(GetStr('DeleteDirectory') + ' "' + Items[ItemIndex].Caption + '"?') then
        OnDirDelete(StripDir(ItemIndex), IdOf(ItemIndex), FItemsList)
      else if IsFile(ItemIndex) and
              Assigned(OnFileDelete) and
              IsConfirm(GetStr('DeleteFile') + ' "' + Items[ItemIndex].Caption + '"?') then
        OnFileDelete(Items[ItemIndex].Caption, IdOf(ItemIndex), FItemsList);
end;

procedure TfrxIOTransportDialogIntForm.CreateDirectoryButtonClick(Sender: TObject);
var
  NewDir: String;
begin
  with DirectoryLV do
    if (ItemIndex >= 0) and InputQuery(GetStr('6483'), '', NewDir) and Assigned(OnDirCreate) then
        OnDirCreate(NewDir, FItemsList);
end;

procedure TfrxIOTransportDialogIntForm.DirectoryListBoxDblClick(Sender: TObject);
begin
  with DirectoryLV do
    if ItemIndex >= 0 then
      if      IsFile(ItemIndex) and (DialogMode in [idmOpen, idmSave]) then
        DialogFileName := Items[ItemIndex].Caption
      else if IsDirectory(ItemIndex) and Assigned(OnDirChange) then
      begin
        StartUpdate;
        OnDirChange(StripDir(ItemIndex), IdOf(ItemIndex), FItemsList);
        EndUpdate;
      end;
end;

procedure TfrxIOTransportDialogIntForm.DirectoryLVClick(Sender: TObject);
begin
  with DirectoryLV do
  if (ItemIndex >= 0) and IsFile(ItemIndex) and (DialogMode in [idmOpen, idmSave]) then
      DialogFileName := Items[ItemIndex].Caption
end;

procedure TfrxIOTransportDialogIntForm.FillTimerTimer(Sender: TObject);
begin
  FillTimer.Enabled := False;
  if not Assigned(FIOTransport) then Exit;
  ClearWithObjects(FItemsList);
  TfrxInternetIOTransport(FIOTransport).GetDirItems(FItemsList);
  EndUpdate;
end;

procedure TfrxIOTransportDialogIntForm.FormCreate(Sender: TObject);
begin
  FItemsList := TStringList.Create;
  TStringList(FItemsList).OnChange := ListChanged;
  Translate(Self);
  DirectoryLV.LargeImages := frxResources.WizardImages;
  DialogMode := idmSave;
end;

procedure TfrxIOTransportDialogIntForm.FormDestroy(Sender: TObject);
begin
  ClearWithObjects(FItemsList);
  FreeAndNil(FItemsList);
end;

procedure TfrxIOTransportDialogIntForm.FormShow(Sender: TObject);
begin
  if Assigned(FIOTransport) then
    StartUpdate;
  FillTimer.Enabled := True;
end;

function TfrxIOTransportDialogIntForm.GetFileName: String;
begin
  Result := FileNameEdit.Text;
end;

function TfrxIOTransportDialogIntForm.GetItems: TStrings;
var
  i: Integer;
begin
  FItemsList.Clear;
  for i := 0 to DirectoryLV.Items.Count - 1 do
    FItemsList.AddObject(DirectoryLV.Items[i].Caption, TObject(DirectoryLV.Items[i].Data));
  Result := FItemsList;
end;

procedure TfrxIOTransportDialogIntForm.IconsSBClick(Sender: TObject);
begin
  IconsSB.Down := False;
  ListSB.Down := False;
  TSpeedButton(Sender).Down := True;
  if Sender = ListSB then
    DirectoryLV.ViewStyle := vsList
  else
    DirectoryLV.ViewStyle := vsIcon;
end;

function TfrxIOTransportDialogIntForm.IdOf(Index: Integer): String;
begin
  with DirectoryLV.Items do
    if Item[Index].Data <> nil then
      Result := TIdObject(Item[Index].Data).Id
    else
      Result := '';
end;

function TfrxIOTransportDialogIntForm.IsConfirm(const Text: String): boolean;
begin
  Result := frxConfirmMsg(Text, mb_YesNo) = mrYes;
end;

function TfrxIOTransportDialogIntForm.IsDirectory(Index: Integer): Boolean;
begin
  with DirectoryLV do
    Result := (Items[Index].Caption[1] = '[') and
              (Items[Index].Caption[Length(Items[Index].Caption)] = ']');
end;

function TfrxIOTransportDialogIntForm.IsFile(Index: Integer): Boolean;
begin
  Result := not IsDirectory(Index);
end;

procedure TfrxIOTransportDialogIntForm.ListChanged(Sender: TObject);
begin
  UpdateListView;
end;

procedure TfrxIOTransportDialogIntForm.SetDialogMode(const Value: TfrxIOInternetDialogMode);
begin
  FDialogMode := Value;
  case FDialogMode of
    idmOpen: Caption := GetStr('IOOpenFile');
    idmSave: Caption := GetStr('IOSaveTO');
    idmDir: Caption := GetStr('IOSelectDir');
  end;
  FileNameLabel.Visible := FDialogMode = idmSave;
  FileNameEdit.Visible := FDialogMode = idmSave;
end;

procedure TfrxIOTransportDialogIntForm.SetFileName(const Value: String);
begin
  FileNameEdit.Text := Value;
end;

procedure TfrxIOTransportDialogIntForm.StartUpdate;
begin
  DirectoryLV.Enabled := False;
  UpdateP.Visible := True;
  Application.ProcessMessages;// remove later
end;

function TfrxIOTransportDialogIntForm.StripDir(Index: Integer): String;
begin
  with DirectoryLV do
    Result := Copy(Items[Index].Caption, 2, Length(Items[Index].Caption) - 2);
end;

procedure TfrxIOTransportDialogIntForm.UpdateListView;
var
  i: Integer;
begin
  DirectoryLV.Items.BeginUpdate;
  DirectoryLV.Items.Clear;
  //DirectoryLV.Items.Add.Caption := '[..]';
//  if FItemsList.IndexOf('[..]') = -1 then
//    FItemsList.AddObject('[..]', nil);
  for i := 0 to FItemsList.Count - 1 do
    with DirectoryLV.Items.Add do
    begin
      Caption := FItemsList[i];
      Data := FItemsList.Objects[i];
      if (Caption[1] = '[') and (Caption[Length(Caption)] = ']') then
        ImageIndex := 6
      else if Pos('.fr3', Caption) > 0 then
        ImageIndex := 8
      else if Pos('.fp3', Caption) > 0 then
        ImageIndex := 9
      else
        ImageIndex := 7;
    end;
  DirectoryLV.Items.EndUpdate;
end;

procedure TfrxIOTransportDialogIntForm.DisableDelete;
begin
{$IfDef Indy9}
// http://stackoverflow.com/questions/42772919/how-to-send-a-delete-request-with-indy-9
  DeleteButton.Enabled := False;
  DeleteButton.Visible := False;
{$EndIf}
end;

procedure TfrxIOTransportDialogIntForm.EndUpdate;
begin
  DirectoryLV.Enabled := True;
  UpdateP.Visible := False;
end;

end.
