
{******************************************}
{                                          }
{              FastReport v6.0             }
{           OneDrive Save Filter           }
{                                          }
{          Copyright (c) 2016-2017         }
{             by Oleg Adibekov,            }
{             Fast Reports Inc.            }
{                                          }
{******************************************}

unit frxIOTransportOneDriveBase;

interface

{$I frx.inc}

uses
  Classes, Forms, Controls, StdCtrls, ComCtrls,
  frxIOTransportHelpers,
  frxBaseTransportConnection;

const
  frx_OneD_UP_URL = 'https://api.onedrive.com/v1.0/drive/root:%s:/children';
  frx_OneD_LF_URL = 'https://api.onedrive.com/v1.0/drive/root:%s:/children?select=name,folder,file';
  frx_OneD_DL_URL = 'https://api.onedrive.com/v1.0/drive/root:%s/%s:/content';
  frx_OneD_DEL_URL = 'https://api.onedrive.com/v1.0/drive/root:%s';
  frx_OneD_CreateDir_URL = 'https://api.onedrive.com/v1.0/drive/root:%s:/children';
  frx_OneD_Boundary = '560310243403';

type
  TfrxOneDriveIOTransportForm = class(TfrxBaseTransportDialog)
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
  TfrxBaseOneDriveIOTransport = class(TfrxHTTPIOTransport)
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

    procedure CreateRemoteDir(DirName: String; ChangeDir: Boolean = True); override;
    function GetListFolder: String; virtual; abstract;
    function GetListFolderContinue(NextLink: String): String; virtual; abstract;
    procedure CreateFolder(Dir: String); virtual; abstract;
    procedure DeleteFileOrFolder(Name: String); virtual; abstract;
  public
    constructor Create(AOwner: TComponent); override;
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
  frxJSON;

{ TfrxOneDriveIOTransportForm }

procedure TfrxOneDriveIOTransportForm.FormCreate(Sender: TObject);
begin
  Translate(Self);

  RequiredLabel.Visible := False;
  UseProxyServerCheckBox.Checked := False;

  FAccessToken := '';
  FErrorMessage := '';
end;

procedure TfrxOneDriveIOTransportForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_F1 then
    frxResources.Help(Self);
end;

procedure TfrxOneDriveIOTransportForm.InitControlsFromFilter(
  TransportFilter: TfrxInternetIOTransport);
var
  aFilter: TfrxBaseOneDriveIOTransport;
begin
  inherited;
  aFilter := TfrxBaseOneDriveIOTransport(TransportFilter);
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
  end
  else
  begin
    ClientIDEdit.Text := aFilter.ClientID;
    RemoteDirComboBox.Text := aFilter.RemoteDir;

    UseProxyServerCheckBox.Checked := aFilter.UseProxyServer;
    ProxyHostComboBox.Text := aFilter.ProxyHost;
    ProxyPortComboBox.Text := IntToStr(aFilter.ProxyPort);
    ProxyUserNameEdit.Text := aFilter.ProxyUserName;
    ProxyPasswordEdit.Text := aFilter.ProxyPassword;
  end;
  aFilter.AssignSharedProperties(aFilter.FOriginalCopy);
  FAccessToken := aFilter.FAccessToken;
end;

procedure TfrxOneDriveIOTransportForm.InitFilterFromDialog(
  TransportFilter: TfrxInternetIOTransport);
var
  aFilter: TfrxBaseOneDriveIOTransport;
begin
  aFilter := TfrxBaseOneDriveIOTransport(TransportFilter);
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

function TfrxOneDriveIOTransportForm.IsFinalURL(URL: String): Boolean;
begin
  FAccessToken := CopySubstring(URL, '#access_token=', '&token_type=');
  if FAccessToken = '' then
    FErrorMessage := CopySubstring(URL, '&error_description=', '');

  Result := FAccessToken + FErrorMessage <> '';
end;

function TfrxOneDriveIOTransportForm.IsGetToken: boolean;
var
  BrowserForm: TBrowserForm;
begin
  Result := (FAccessToken <> '');
  if Result then Exit;
  BrowserForm := TBrowserForm.Create(nil);
  try
    BrowserForm.URL := 'https://login.live.com/oauth20_authorize.srf?' +
                       'client_id=' + ClientIDEdit.Text + '&' +
                       'scope=onedrive.readwrite' + '&' +
                       'response_type=token' + '&' +
                       'redirect_uri=https://login.live.com/oauth20_desktop.srf';
    BrowserForm.OnTestURL := IsFinalURL;

    Result := (BrowserForm.ShowModal = mrOK) and (AccessToken <> '');
  finally
    BrowserForm.Free;
  end;
end;

procedure TfrxOneDriveIOTransportForm.OkBClick(Sender: TObject);
const
  URL = 'https://api.onedrive.com/v1.0/drive/root:/:/children?select=folder';
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
  FFilter.TestToken(URL, FAccessToken);
  if (ModalResult = mrOK) and not IsGetToken then
  begin
    if FErrorMessage <> '' then
      frxErrorMsg(FErrorMessage);
    ModalResult := mrCancel;
  end;
end;

procedure TfrxOneDriveIOTransportForm.ProxyPortComboBoxKeyPress(Sender: TObject;
  var Key: Char);
begin
  case Key of
    '0' .. '9': ;
    #8: ;
  else
    Key := #0;
  end;
end;

procedure TfrxOneDriveIOTransportForm.RequireIf(L: TLabel; Flag: Boolean;
  MR: integer = mrNone);
begin
  if Flag then
  begin
    L.Font.Style := [fsBold];
    L.Font.Color := clRed;
    ModalResult := MR;
  end;
end;

{ TfrxOneDriveIOTransport }

constructor TfrxBaseOneDriveIOTransport.Create(AOwner: TComponent);
begin
  inherited;

end;

procedure TfrxBaseOneDriveIOTransport.CreateRemoteDir(DirName: String;
  ChangeDir: Boolean);
begin
  CreateFolder(DirName);
  if ChangeDir then
    RemoteDir := RemoteDir + DirName;
end;

procedure TfrxBaseOneDriveIOTransport.DialogDirChange(Name, Id: String;
  DirItems: TStrings);
begin
  RemoteDir := PathChangeDir(RemoteDir, Name);
  GetDirItems(DirItems);
end;

procedure TfrxBaseOneDriveIOTransport.DialogDirCreate(Name: String;
  DirItems: TStrings);
begin
  CreateFolder(Name);
  GetDirItems(DirItems);
end;

procedure TfrxBaseOneDriveIOTransport.DialogDirDelete(Name, Id: String;
  DirItems: TStrings);
begin
  DeleteFileOrFolder(Name);
  GetDirItems(DirItems);
end;

procedure TfrxBaseOneDriveIOTransport.DialogFileDelete(Name, Id: String;
  DirItems: TStrings);
begin
  DeleteFileOrFolder(Name);
  GetDirItems(DirItems);
end;

function TfrxBaseOneDriveIOTransport.FilterSection: String;
begin
  Result := 'OneDriveFilter';
end;

class function TfrxBaseOneDriveIOTransport.GetDescription: String;
begin
  Result := frxResources.Get('OneDriveIOTransport');
end;

procedure TfrxBaseOneDriveIOTransport.GetDirItems(DirItems: TStrings; aFilter: String);
var
  HasMore: Boolean;
  NextLink: String;

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
            IsNameExists('folder'), IsNameExists('file'),
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

    FillDirItems(TfrxJSONArray.Create(frxJSON.ObjectByName('value')));

    HasMore := frxJSON.IsNameExists('@odata.nextLink');
    if HasMore then
      NextLink := frxJSON.ValueByName('@odata.nextLink');
    frxJSON.Free;
  end;

begin
  DirItems.BeginUpdate;
  ClearWithObjects(DirItems);
  GetJSONList(TfrxJSON.Create(GetListFolder));
  while HasMore do
    GetJSONList(TfrxJSON.Create(GetListFolderContinue(NextLink)));
  DirItems.EndUpdate;
end;

function TfrxBaseOneDriveIOTransport.GetRemoteDir: String;
begin
  Result := FRemoteDir;
  if (Length(Result) = 0) or (Result[Length(Result)] <> '/') then Result := Result + '/';
end;

procedure TfrxBaseOneDriveIOTransport.SetRemoteDir(const Value: String);
begin
  FRemoteDir := PathFirstSlash(Value);
end;

procedure TfrxBaseOneDriveIOTransport.TestRemoteDir;
begin
  try
    GetListFolder;
  except
    raise Exception.Create(Format(
      'Can''t change directory to %s: No such directory.',
      [RemoteDir]));
  end;
end;

class function TfrxBaseOneDriveIOTransport.TransportDialogClass: TfrxBaseTransportDialogClass;
begin
  Result := TfrxOneDriveIOTransportForm;
end;

(* Work Ok with Indy 10 only
procedure TfrxOneDriveIOTransport.Upload(const SourceFileName: String;
  DestFileName: String = '');
const
  URL = 'https://api.onedrive.com/v1.0/drive/root:%s/%s:/content';
var
  Source: TFileStream;
begin
  FHTTP.Request.ContentType := 'application/octet-stream';
  {$IfNDef Indy9} FHTTP.Request.CharSet:=''; {$EndIf}

  Source := TFileStream.Create(SourceFileName, fmOpenRead);
  If DestFileName = '' then
    DestFileName := ExtractFileName(SourceFileName);

  try
    FHTTP.Put(TIdURI.URLEncode(Format(URL, [SureUTF8(RemoteDir), SureUTF8(DestFileName)])),
              Source);
  finally
    Source.Free;
  end;
end;
*)

end.
