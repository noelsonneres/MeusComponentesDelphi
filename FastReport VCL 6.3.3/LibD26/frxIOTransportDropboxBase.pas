
{******************************************}
{                                          }
{              FastReport v6.0             }
{            Dropbox Save Filter           }
{                                          }
{          Copyright (c) 2016-2017         }
{             by Oleg Adibekov,            }
{             Fast Reports Inc.            }
{                                          }
{******************************************}

unit frxIOTransportDropboxBase;

interface

{$I frx.inc}

uses
  Classes, Forms, Controls, StdCtrls, ComCtrls,
  frxClass, frxIOTransportHelpers, frxBaseTransportConnection;

  const FRX_DBOX_DL_URL = 'https://content.dropboxapi.com/2/files/download';
  const FRX_DBOX_UL_URL = 'https://content.dropboxapi.com/2/files/upload';

type
  TfrxDropboxIOTransportForm = class(TfrxBaseTransportDialog)
    OkB: TButton;
    CancelB: TButton;
    RequiredLabel: TLabel;
    RememberPropertiesCheckBox: TCheckBox;
    PageControl: TPageControl;
    GeneralTabSheet: TTabSheet;
    ClientIDEdit: TEdit;
    ClientIDLabel: TLabel;
    RemoteDirComboBox: TComboBox;
    RemoteDirLabel: TLabel;
    ProxyTabSheet: TTabSheet;
    UseProxyServerCheckBox: TCheckBox;
    ProxyPasswordLabel: TLabel;
    ProxyUserNameLabel: TLabel;
    ProxyPortLabel: TLabel;
    ProxyHostLabel: TLabel;
    ProxyPasswordEdit: TEdit;
    ProxyUserNameEdit: TEdit;
    ProxyPortComboBox: TComboBox;
    ProxyHostComboBox: TComboBox;
    UserNameLabel: TLabel;
    PasswordLabel: TLabel;
    UserNameEdit: TEdit;
    PasswordEdit: TEdit;
    PassLoginCB: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure OkBClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ProxyPortComboBoxKeyPress(Sender: TObject; var Key: Char);
    procedure PassLoginCBClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  protected
    function IsFinalURL(URL: String): Boolean;
    procedure DocumentComplet(Sender: TObject);
    procedure UpdateControls;
    procedure InitControlsFromFilter(TransportFilter: TfrxInternetIOTransport); override;
    procedure InitFilterFromDialog(TransportFilter: TfrxInternetIOTransport); override;
  private
    FAccessToken: String;
    FErrorMessage: String;

    procedure RequireIf(L: TLabel; Flag: Boolean; MR: integer = mrNone);
    function IsGetToken: boolean;
  public
    property AccessToken: String read FAccessToken;
    property ErrorMessage: String read FErrorMessage;
  end;

{$IFDEF DELPHI16}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64)]
{$ENDIF}
  TfrxBaseDropboxIOTransport = class(TfrxHTTPIOTransport)
  private
    procedure SetRemoteDir(const Value: String);
    function GetRemoteDir: String;
  protected
    function FilterSection: String; override;

    procedure TestRemoteDir; override;
    procedure DialogDirChange(Name, Id: String; DirItems: TStrings); override;
    procedure DialogDirCreate(Name: String; DirItems: TStrings); override;
    procedure DialogFileDelete(Name, Id: String; DirItems: TStrings); override;
    procedure DialogDirDelete(Name, Id: String; DirItems: TStrings); override;

    function FolderAPI(const URL, Source: String): String; virtual; abstract;
    function GetListFolder: String;
    function GetListFolderContinue(Cursor: String): String;
    procedure CreateFolder(Dir: String);
    procedure CreateRemoteDir(DirName: String; ChangeDir: Boolean = True); override;
    procedure DeleteFileOrFolder(Name: String);
    function IsDeleteSupported: Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure AssignSharedProperties(Source: TfrxCustomIOTransport); override;
    class function GetDescription: String; override;
    class function TransportDialogClass: TfrxBaseTransportDialogClass; override;
    procedure GetDirItems(DirItems: TStrings; aFilter: String = ''); override;
  published
    property RemoteDir: String read GetRemoteDir write SetRemoteDir;
  end;

implementation

{$R *.dfm}

uses
  Windows, SysUtils, Graphics,
  frxMapHelpers, frxRes, frxSaveFilterBrowser, frxUtils, 
  frxJSON, Variants, StrUtils;

{ TfrxDropboxIOTransportForm }

procedure TfrxDropboxIOTransportForm.DocumentComplet(Sender: TObject);
var
  element, doc: Variant;
begin
  if not PassLoginCB.Checked then Exit;
  doc := TBrowserForm(Sender).WebBrowser.Document;

  if not VarIsClear(doc) then
  begin
    element := doc.all.item('login_email');
    if not VarIsClear(element) then
    begin
      element.Value := UserNameEdit.Text;
      IUnknown(element)._Release;
    end;
    VarClear(element);

    element := doc.all.item('login_password');
    if not VarIsClear(element) then
    begin
      element.Value := PasswordEdit.Text;
      IUnknown(element)._Release;
    end;
    VarClear(element);
    IUnknown(doc)._Release;
    VarClear(doc);
  end;
end;

procedure TfrxDropboxIOTransportForm.FormCreate(Sender: TObject);
begin
  Translate(Self);

  RequiredLabel.Visible := False;
  UseProxyServerCheckBox.Checked := False;

  FAccessToken := '';
  FErrorMessage := '';
end;

procedure TfrxDropboxIOTransportForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_F1 then
    frxResources.Help(Self);
end;

procedure TfrxDropboxIOTransportForm.FormShow(Sender: TObject);
begin
  UpdateControls;
end;

procedure TfrxDropboxIOTransportForm.InitControlsFromFilter(
  TransportFilter: TfrxInternetIOTransport);
var
  aFilter: TfrxBaseDropboxIOTransport;
begin
  inherited;
  aFilter := TfrxBaseDropboxIOTransport(TransportFilter);
  RememberPropertiesCheckBox.Visible := aFilter.UseIniFile;
  if aFilter.UseIniFile then
  begin
    IniLoadEdit(ClientIDEdit);
    IniLoadComboBoxWithItems(RemoteDirComboBox);
    aFilter.ClientID := ClientIDEdit.Text;
    IniLoadCheckBox(UseProxyServerCheckBox);
    IniLoadComboBoxWithItems(ProxyHostComboBox);
    IniLoadComboBoxWithItems(ProxyPortComboBox);
    IniLoadEdit(ProxyUserNameEdit);
    IniLoadEdit(ProxyPasswordEdit);
    IniLoadEdit(UserNameEdit);
    IniLoadEdit(PasswordEdit);
  end
  else
  begin
    ClientIDEdit.Text := TfrxBaseDropboxIOTransport(TransportFilter).ClientID;
    RemoteDirComboBox.Text := aFilter.RemoteDir;
    UseProxyServerCheckBox.Checked := aFilter.UseProxyServer;
    ProxyHostComboBox.Text := aFilter.ProxyHost;
    ProxyPortComboBox.Text := IntToStr(aFilter.ProxyPort);
    ProxyUserNameEdit.Text := aFilter.ProxyUserName;
    ProxyPasswordEdit.Text := aFilter.ProxyPassword;
    UserNameEdit.Text := aFilter.UserName;
    PasswordEdit.Text := aFilter.Password;
  end;
  aFilter.AssignSharedProperties(aFilter.FOriginalCopy);
  FAccessToken := aFilter.FAccessToken;
end;

procedure TfrxDropboxIOTransportForm.InitFilterFromDialog(
  TransportFilter: TfrxInternetIOTransport);
var
  aFilter: TfrxBaseDropboxIOTransport;
begin
  aFilter := TfrxBaseDropboxIOTransport(TransportFilter);
  aFilter.FAccessToken := FAccessToken;

  aFilter.ClientID := ClientIDEdit.Text;
  aFilter.RemoteDir := RemoteDirComboBox.Text;

  aFilter.UseProxyServer := UseProxyServerCheckBox.Checked;
  aFilter.ProxyHost := ProxyHostComboBox.Text;
  aFilter.ProxyPort := StrToIntDef(ProxyPortComboBox.Text, aFilter.DefaultProxyPort);
  aFilter.ProxyUserName := ProxyUserNameEdit.Text;
  aFilter.ProxyPassword := ProxyPasswordEdit.Text;
  if aFilter.UseIniFile then
  begin
    IniSaveComboBoxItem(RemoteDirComboBox);
    IniSaveComboBoxItem(ProxyHostComboBox);
    IniSaveComboBoxItem(ProxyPortComboBox);

    if RememberPropertiesCheckBox.Checked then
    begin
      IniSaveEdit(ClientIDEdit);
      IniSaveComboBox(RemoteDirComboBox);
      IniSaveCheckBox(UseProxyServerCheckBox);
      IniSaveComboBox(ProxyHostComboBox);
      IniSaveComboBox(ProxyPortComboBox);
      IniSaveEdit(ProxyUserNameEdit);
      IniSaveEdit(ProxyPasswordEdit);
    end;
  end;
  inherited;
end;

function TfrxDropboxIOTransportForm.IsFinalURL(URL: String): Boolean;
begin
  FAccessToken := CopySubstring(URL, '#access_token=', '&token_type=');
  if FAccessToken = '' then
    FErrorMessage := CopySubstring(URL, '#error_description=', '&error=');

  Result := FAccessToken + FErrorMessage <> '';
end;

function TfrxDropboxIOTransportForm.IsGetToken: boolean;
var
  BrowserForm: TBrowserForm;
begin
  Result := (FAccessToken <> '');
  if Result then Exit;
  BrowserForm := TBrowserForm.Create(nil);
  try
    BrowserForm.URL := 'https://www.dropbox.com/oauth2/authorize?' +
                       'response_type=token' + '&' +
                       'client_id=' + ClientIDEdit.Text + '&' +
                       'redirect_uri=http://localhost';
    BrowserForm.OnTestURL := IsFinalURL;
    BrowserForm.OnDocumentComplet := DocumentComplet;

    Result := (BrowserForm.ShowModal = mrOK) and (AccessToken <> '');
  finally
    BrowserForm.Free;
  end;
end;

procedure TfrxDropboxIOTransportForm.OkBClick(Sender: TObject);
const
  URL = 'https://api.dropboxapi.com/2/users/get_space_usage';
var
  ClientIDRequired, ProxyHostRequired: Boolean;
begin
  ClearLabelsFontStyle(Self);

  RequireIf(RequiredLabel, True, mrOK);

  ClientIDRequired := ClientIDEdit.Text = '';
  RequireIf(ClientIDLabel, ClientIDRequired);

  ProxyHostRequired := (UseProxyServerCheckBox.Checked)
                   and (ProxyHostComboBox.Text = '');
  RequireIf(ProxyHostLabel, ProxyHostRequired);

  if ClientIDRequired then
    PageControl.ActivePage := GeneralTabSheet
  else if ProxyHostRequired then
    PageControl.ActivePage := ProxyTabSheet;

  RequiredLabel.Visible := ModalResult = mrNone;
  FFilter.TestToken(URL, FAccessToken, True);
  if (ModalResult = mrOK) and not IsGetToken then
  begin
    if FErrorMessage <> '' then
      frxErrorMsg(FErrorMessage);
    ModalResult := mrCancel;
  end;
end;

procedure TfrxDropboxIOTransportForm.PassLoginCBClick(Sender: TObject);
begin
  UpdateControls;
end;

procedure TfrxDropboxIOTransportForm.ProxyPortComboBoxKeyPress(Sender: TObject;
  var Key: Char);
begin
  case Key of
    '0' .. '9': ;
    #8: ;
  else
    Key := #0;
  end;
end;

procedure TfrxDropboxIOTransportForm.RequireIf(L: TLabel; Flag: Boolean;
  MR: integer = mrNone);
begin
  if Flag then
  begin
    L.Font.Style := [fsBold];
    L.Font.Color := clRed;
    ModalResult := MR;
  end;
end;

procedure TfrxDropboxIOTransportForm.UpdateControls;
begin
  UserNameLabel.Enabled := PassLoginCB.Checked;
  UserNameEdit.Enabled := PassLoginCB.Checked;
  PasswordLabel.Enabled := PassLoginCB.Checked;
  PasswordEdit.Enabled := PassLoginCB.Checked;
end;

{ TfrxDropboxIOTransport }

procedure TfrxBaseDropboxIOTransport.AssignSharedProperties(
  Source: TfrxCustomIOTransport);
begin
  FAccessToken := TfrxBaseDropboxIOTransport(Source).FAccessToken;
end;

constructor TfrxBaseDropboxIOTransport.Create(AOwner: TComponent);
begin
  inherited;
end;

procedure TfrxBaseDropboxIOTransport.CreateFolder(Dir: String);
const
  URL = 'https://api.dropboxapi.com/2/files/create_folder';
begin
  FolderAPI(URL, Format('{ "path": "%s" }', [SureUTF8(RemoteDir + Dir)]));
end;

procedure TfrxBaseDropboxIOTransport.CreateRemoteDir(DirName: String;
  ChangeDir: Boolean);
begin
  CreateFolder(DirName);
  if ChangeDir then
    RemoteDir := RemoteDir + DirName;
end;

procedure TfrxBaseDropboxIOTransport.DeleteFileOrFolder(Name: String);
const
  URL = 'https://api.dropboxapi.com/2/files/delete';
begin
  FolderAPI(URL, Format('{ "path": "%s" }', [SureUTF8(RemoteDir + Name)]));
end;

procedure TfrxBaseDropboxIOTransport.DialogDirChange(Name, Id: String;
  DirItems: TStrings);
begin
  RemoteDir := PathChangeDir(RemoteDir, Name);
  GetDirItems(DirItems);
end;

procedure TfrxBaseDropboxIOTransport.DialogDirCreate(Name: String;
  DirItems: TStrings);
begin
  CreateFolder(Name);
  GetDirItems(DirItems);
end;

procedure TfrxBaseDropboxIOTransport.DialogDirDelete(Name, Id: String;
  DirItems: TStrings);
begin
  DeleteFileOrFolder(Name);
  GetDirItems(DirItems);
end;

procedure TfrxBaseDropboxIOTransport.DialogFileDelete(Name, Id: String;
  DirItems: TStrings);
begin
  DeleteFileOrFolder(Name);
  GetDirItems(DirItems);
end;

function TfrxBaseDropboxIOTransport.FilterSection: String;
begin
  Result := 'DropboxFilter';
end;

class function TfrxBaseDropboxIOTransport.GetDescription: String;
begin
  Result := frxResources.Get('DropboxIOTransport');
end;

procedure TfrxBaseDropboxIOTransport.GetDirItems(DirItems: TStrings; aFilter: String);
var
  HasMore: Boolean;
  Cursor: String;

  procedure FillDirItems(frxJSONArray: TfrxJSONArray);
  var
    i: Integer;
  begin
    if RemoteDir <> '' then // Up directory
      AddToDirItems(DirItems, True, False, '..');

    for i := 0 to frxJSONArray.Count - 1 do
      with frxJSONArray.Get(i) do
        try
          AddToDirItems(DirItems,
            ValueByName('.tag') = 'folder', ValueByName('.tag') = 'file',
            ValueByName('name'));
        finally
          Free;
        end;
    frxJSONArray.Free;
  end;

  procedure GetJSONList(frxJSON: TfrxJSON);
  begin
    if not Assigned(frxJSON) then
      raise Exception.Create('Non valid JSON data');

    FillDirItems(TfrxJSONArray.Create(frxJSON.ObjectByName('entries')));

    HasMore := frxJSON.ValueByName('has_more') = 'true';
    if HasMore then
      Cursor := frxJSON.ValueByName('cursor');
    frxJSON.Free;
  end;

begin
  DirItems.BeginUpdate;
  ClearWithObjects(DirItems);
  GetJSONList(TfrxJSON.Create(GetListFolder));
  while HasMore do
    GetJSONList(TfrxJSON.Create(GetListFolderContinue(Cursor)));
  DirItems.EndUpdate;
end;

function TfrxBaseDropboxIOTransport.GetListFolder: String;
const
  URL = 'https://api.dropboxapi.com/2/files/list_folder';
begin
  Result := FolderAPI(URL, Format('{ "path": "%s" }', [SureUTF8(RemoteDir)]));
end;

function TfrxBaseDropboxIOTransport.GetListFolderContinue(Cursor: String): String;
const
  URL = 'https://api.dropboxapi.com/2/files/list_folder/continue';
begin
  Result := FolderAPI(URL, Format('{ "cursor": "%s" }', [Cursor]));
end;

function TfrxBaseDropboxIOTransport.GetRemoteDir: String;
begin
  Result := FRemoteDir;
  if (Length(Result) = 0) or (Length(Result) > 0) and (Result[Length(Result)] <> '/') then Result := Result + '/';
end;

function TfrxBaseDropboxIOTransport.IsDeleteSupported: Boolean;
begin
  Result := True;
end;

procedure TfrxBaseDropboxIOTransport.SetRemoteDir(const Value: String);
begin
  FRemoteDir := PathFirstSlash(Value);
end;

procedure TfrxBaseDropboxIOTransport.TestRemoteDir;
begin
  try
    GetListFolder;
  except
    raise;
//    Exception.Create(Format(
//      'Can''t change directory to %s: No such directory.',
//      [RemoteDir]));
  end;
end;

class function TfrxBaseDropboxIOTransport.TransportDialogClass: TfrxBaseTransportDialogClass;
begin
  Result := TfrxDropboxIOTransportForm;
end;

end.
