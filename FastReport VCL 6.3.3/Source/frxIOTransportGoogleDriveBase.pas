
{******************************************}
{                                          }
{              FastReport v6.0             }
{          GoogleDrive Save Filter         }
{                                          }
{            Copyright (c) 2017            }
{             by Oleg Adibekov,            }
{             Fast Reports Inc.            }
{                                          }
{******************************************}

unit frxIOTransportGoogleDriveBase;

interface

{$I frx.inc}

uses
  Classes, Forms, Controls, StdCtrls, ComCtrls,
  frxIOTransportHelpers, frxBaseTransportConnection;

const
// You can use the alias 'root' to refer to the root folder anywhere a file ID is provided
  frx_GoogleDrive_RootFolderId = 'root';
// In the Drive API, a folder is essentially a file — one identified by the special folder MIME type
  frx_GoogleDrive_MimeFolder = 'application/vnd.google-apps.folder';
  frx_GoogleDrive_CreateDir_URL = 'https://www.googleapis.com/drive/v3/files';
  frx_GoogleDrive_Delete_URL = 'https://www.googleapis.com/drive/v3/files/%s';
  frx_GoogleDrive_Download_URL = 'https://www.googleapis.com/drive/v3/files/%s?alt=media';
  frx_GoogleDrive_GetToken_URL = 'https://www.googleapis.com/oauth2/v4/token';
  frx_GoogleDrive_ListDir_URL = 'https://www.googleapis.com/drive/v3/files?q=''%s''+in+parents%s';
  frx_GoogleDrive_ListDirContinue_URL = 'https://www.googleapis.com/drive/v3/files?q=''%s''+in+parents%s&pageToken=%s';
  frx_GoogleDrive_Upload_URL = 'https://www.googleapis.com/upload/drive/v3/files?uploadType=multipart';

type
  TfrxGoogleDriveIOTransportForm = class(TfrxBaseTransportDialog)
    OkB: TButton;
    CancelB: TButton;
    RequiredLabel: TLabel;
    RememberPropertiesCheckBox: TCheckBox;
    PageControl: TPageControl;
    GeneralTabSheet: TTabSheet;
    ClientIDEdit: TEdit;
    ClientIDLabel: TLabel;
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
    ClientSecretEdit: TEdit;
    ClientSecretLabel: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure OkBClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ProxyPortComboBoxKeyPress(Sender: TObject; var Key: Char);
  protected
    function IsFinalURL(URL: String): Boolean;
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
  TfrxBaseGoogleDriveIOTransport = class(TfrxHTTPIOTransport)
  protected
    FClientSecret: String;
    FDirStack: TDirStack;
    function FilterSection: String; override;
    procedure DialogDirChange(Name, Id: String; DirItems: TStrings); override;
    procedure DialogDirCreate(Name: String; DirItems: TStrings); override;
    procedure DialogFileDelete(Name, Id: String; DirItems: TStrings); override;
    procedure DialogDirDelete(Name, Id: String; DirItems: TStrings); override;

    procedure CreateRemoteDir(DirName: String; ChangeDir: Boolean = True); override;
    procedure ChangeDirUP; override;
    function GetListFolder(aFilter: String = ''): String; virtual; abstract;
    function GetListFolderContinue(NextPageToken: String; aFilter: String = ''): String; virtual; abstract;
    procedure CreateFolder(Dir: String); virtual; abstract;
    procedure DeleteFileOrFolder(const Id: String); virtual; abstract;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    class function TransportDialogClass: TfrxBaseTransportDialogClass; override;
    class function GetDescription: String; override;
    procedure GetDirItems(DirItems: TStrings; aFilter: String = ''); override;
    function GetAccessToken(AuthorizationCode, ClientId, ClientSecret: String; var ErrorMsg: String): String; virtual; abstract;
  published
    property ClientSecret : String read FClientSecret write FClientSecret;
  end;

implementation

{$R *.dfm}

uses
  Windows, SysUtils, Graphics,
  frxMapHelpers, frxRes, frxSaveFilterBrowser, frxUtils,
  frxJSON;

{ TfrxGoogleDriveIOTransportForm }

procedure TfrxGoogleDriveIOTransportForm.FormCreate(Sender: TObject);
begin
  Translate(Self);

  RequiredLabel.Visible := False;
  UseProxyServerCheckBox.Checked := False;

  FAccessToken := '';
  FErrorMessage := '';
end;

procedure TfrxGoogleDriveIOTransportForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_F1 then
    frxResources.Help(Self);
end;

procedure TfrxGoogleDriveIOTransportForm.InitControlsFromFilter(
  TransportFilter: TfrxInternetIOTransport);
var
  aFilter: TfrxBaseGoogleDriveIOTransport;
begin
  inherited;
  aFilter := TfrxBaseGoogleDriveIOTransport(TransportFilter);
  RememberPropertiesCheckBox.Visible := aFilter.UseIniFile;
  if aFilter.UseIniFile then
  begin
    IniLoadEdit(ClientIDEdit);
    aFilter.ClientID := ClientIDEdit.Text;
    IniLoadEdit(ClientSecretEdit);
    IniLoadCheckBox(UseProxyServerCheckBox);
    IniLoadComboBoxWithItems(ProxyHostComboBox);
    IniLoadComboBoxWithItems(ProxyPortComboBox);
    IniLoadEdit(ProxyUserNameEdit);
    IniLoadEdit(ProxyPasswordEdit);
  end
  else
  begin
    ClientIDEdit.Text := aFilter.ClientID;
    ClientSecretEdit.Text := aFilter.ClientSecret;
    UseProxyServerCheckBox.Checked := aFilter.UseProxyServer;
    ProxyHostComboBox.Text := aFilter.ProxyHost;
    ProxyPortComboBox.Text := IntToStr(aFilter.ProxyPort);
    ProxyUserNameEdit.Text := aFilter.ProxyUserName;
    ProxyPasswordEdit.Text := aFilter.ProxyPassword;
  end;
  aFilter.AssignSharedProperties(aFilter.FOriginalCopy);
  FAccessToken := aFilter.FAccessToken;
end;

procedure TfrxGoogleDriveIOTransportForm.InitFilterFromDialog(
  TransportFilter: TfrxInternetIOTransport);
var
  aFilter: TfrxBaseGoogleDriveIOTransport;
begin
  aFilter := TfrxBaseGoogleDriveIOTransport(TransportFilter);
  aFilter.FAccessToken := FAccessToken;

  aFilter.ClientID := ClientIDEdit.Text;
  aFilter.ClientSecret := ClientSecretEdit.Text;

  aFilter.UseProxyServer := UseProxyServerCheckBox.Checked;
  aFilter.ProxyHost := ProxyHostComboBox.Text;
  aFilter.ProxyPort := StrToIntDef(ProxyPortComboBox.Text, aFilter.DefaultProxyPort);
  aFilter.ProxyUserName := ProxyUserNameEdit.Text;
  aFilter.ProxyPassword := ProxyPasswordEdit.Text;
  if aFilter.UseIniFile then
  begin
    IniSaveComboBoxItem(ProxyHostComboBox);
    IniSaveComboBoxItem(ProxyPortComboBox);
    if RememberPropertiesCheckBox.Checked then
    begin
      IniSaveEdit(ClientIDEdit);
      IniSaveEdit(ClientSecretEdit);
      IniSaveCheckBox(UseProxyServerCheckBox);
      IniSaveComboBox(ProxyHostComboBox);
      IniSaveComboBox(ProxyPortComboBox);
      IniSaveEdit(ProxyUserNameEdit);
      IniSaveEdit(ProxyPasswordEdit);
    end;
  end;
  inherited;
end;

function TfrxGoogleDriveIOTransportForm.IsFinalURL(URL: String): Boolean;
var
  AuthorizationCode: String;
begin
  AuthorizationCode := CopySubstring(URL, '?code=', '');
  if AuthorizationCode <> ''  then
    FAccessToken := TfrxBaseGoogleDriveIOTransport(FFilter)
      .GetAccessToken(AuthorizationCode, ClientIDEdit.Text,
      ClientSecretEdit.Text, FErrorMessage)
  else
    FErrorMessage := CopySubstring(URL, '?error=', '');

  Result := FAccessToken + FErrorMessage <> '';
end;

function TfrxGoogleDriveIOTransportForm.IsGetToken: boolean;
var
  BrowserForm: TBrowserForm;
begin
  Result := (FAccessToken <> '');
  if Result then Exit;
  BrowserForm := TBrowserForm.Create(nil);
  try
    BrowserForm.URL := 'https://accounts.google.com/o/oauth2/v2/auth?' +
                       'client_id=' + ClientIDEdit.Text + '&' +
                       'redirect_uri=http://localhost&' +
                       'response_type=code&' +
                       'scope=https://www.googleapis.com/auth/drive';
    BrowserForm.OnTestURL := IsFinalURL;

    Result := (BrowserForm.ShowModal = mrOK) and (AccessToken <> '');
    if not Result then
      FErrorMessage := FErrorMessage + BrowserForm.NavigateHistory.Text;
  finally
    BrowserForm.Free;
  end;
end;

procedure TfrxGoogleDriveIOTransportForm.OkBClick(Sender: TObject);
const
  URL = 'https://www.googleapis.com/drive/v3/files?q=''root''+in+parents+and+name=''testaccesstokenconnection.fastreport''';
var
  ClientIDRequired, ClientSecretRequired, ProxyHostRequired: Boolean;
begin
  ClearLabelsFontStyle(Self);

  RequireIf(RequiredLabel, True, mrOK);

  ClientIDRequired := ClientIDEdit.Text = '';
  RequireIf(ClientIDLabel, ClientIDRequired);

  ClientSecretRequired := ClientSecretEdit.Text = '';
  RequireIf(ClientSecretLabel, ClientSecretRequired);

  ProxyHostRequired := (UseProxyServerCheckBox.Checked)
                   and (ProxyHostComboBox.Text = '');
  RequireIf(ProxyHostLabel, ProxyHostRequired);

  if ClientIDRequired or ClientSecretRequired then
    PageControl.ActivePage := GeneralTabSheet
  else if ProxyHostRequired then
    PageControl.ActivePage := ProxyTabSheet;

  RequiredLabel.Visible := ModalResult = mrNone;

  FFilter.TestToken(URL, FAccessToken);

  if (ModalResult = mrOK) and not IsGetToken then
  begin
    if FErrorMessage <> '' then
      frxErrorMsg(FErrorMessage);
    ModalResult := mrCancel;
  end;
end;

procedure TfrxGoogleDriveIOTransportForm.ProxyPortComboBoxKeyPress(Sender: TObject;
  var Key: Char);
begin
  case Key of
    '0' .. '9': ;
    #8: ;
  else
    Key := #0;
  end;
end;

procedure TfrxGoogleDriveIOTransportForm.RequireIf(L: TLabel; Flag: Boolean;
  MR: integer = mrNone);
begin
  if Flag then
  begin
    L.Font.Style := [fsBold];
    L.Font.Color := clRed;
    ModalResult := MR;
  end;
end;

{ TfrxGoogleDriveIOTransport }

procedure TfrxBaseGoogleDriveIOTransport.ChangeDirUP;
begin
  FDirStack.Pop;
end;

constructor TfrxBaseGoogleDriveIOTransport.Create(AOwner: TComponent);
begin
  inherited;

  FClientSecret := '';

  FDirStack := TDirStack.Create(frx_GoogleDrive_RootFolderId);
end;

procedure TfrxBaseGoogleDriveIOTransport.CreateRemoteDir(DirName: String;
  ChangeDir: Boolean);
var
  sList: TStringList;
  sID: String;
  Index: Integer;
begin
  CreateFolder(DirName);
  if not ChangeDir then Exit;
   sID := '';
  SList := TStringList.Create;
   try
    GetDirItems(sList, DirName);
    Index := sList.IndexOf('[' + DirName + ']');
    if Index <> -1 then
      sID := TIdObject(sList.Objects[Index]).Id;

    if sID <> '' then
      FDirStack.Push(sID);
  finally
    sList.Free;
  end;
end;

destructor TfrxBaseGoogleDriveIOTransport.Destroy;
begin
  FDirStack.Free;
  inherited;
end;

procedure TfrxBaseGoogleDriveIOTransport.DialogDirChange(Name, Id: String;
  DirItems: TStrings);
begin
  if Name = '..' then
    FDirStack.Pop
  else
    FDirStack.Push(Id);
  GetDirItems(DirItems);
end;

procedure TfrxBaseGoogleDriveIOTransport.DialogDirCreate(Name: String;
  DirItems: TStrings);
begin
  CreateFolder(Name);
  GetDirItems(DirItems);
end;

procedure TfrxBaseGoogleDriveIOTransport.DialogDirDelete(Name, Id: String;
  DirItems: TStrings);
begin
  DeleteFileOrFolder(Id);
  GetDirItems(DirItems);
end;

procedure TfrxBaseGoogleDriveIOTransport.DialogFileDelete(Name, Id: String;
  DirItems: TStrings);
begin
  DeleteFileOrFolder(Id);
  GetDirItems(DirItems);
end;

function TfrxBaseGoogleDriveIOTransport.FilterSection: String;
begin
  Result := 'GoogleDriveFilter';
end;

class function TfrxBaseGoogleDriveIOTransport.GetDescription: String;
begin
  Result := frxResources.Get('GoogleDriveIOTransport');
end;

procedure TfrxBaseGoogleDriveIOTransport.GetDirItems(DirItems: TStrings; aFilter: String);
var
  HasMore: Boolean;
  NextPageToken: String;

  procedure FillDirItems(frxJSONArray: TfrxJSONArray);
  var
    i: Integer;
  begin
    if FDirStack.Top <> frx_GoogleDrive_RootFolderId then // Up directory
      AddToDirItems(DirItems, True, False, '..', FDirStack.Top);

    for i := 0 to frxJSONArray.Count - 1 do
      with frxJSONArray.Get(i) do
        try
          AddToDirItems(DirItems,
            ValueByName('mimeType') = frx_GoogleDrive_MimeFolder, True,
            ValueByName('name'),            ValueByName('id'));
        finally
          Free;
        end;
    frxJSONArray.Free;
  end;

  procedure GetJSONList(frxJSON: TfrxJSON);
  begin
    if not Assigned(frxJSON) then
      raise Exception.Create('Non valid JSON data');

    FillDirItems(TfrxJSONArray.Create(frxJSON.ObjectByName('files')));

    HasMore := frxJSON.IsNameExists('nextPageToken');
    if HasMore then
      NextPageToken := frxJSON.ValueByName('nextPageToken');
    frxJSON.Free;
  end;

begin
  DirItems.BeginUpdate;
  ClearWithObjects(DirItems);
  GetJSONList(TfrxJSON.Create(GetListFolder(aFilter)));
  while HasMore do
    GetJSONList(TfrxJSON.Create(GetListFolderContinue(NextPageToken, aFilter)));
  DirItems.EndUpdate;
end;

class function TfrxBaseGoogleDriveIOTransport.TransportDialogClass: TfrxBaseTransportDialogClass;
begin
  Result := TfrxGoogleDriveIOTransportForm;
end;

end.
