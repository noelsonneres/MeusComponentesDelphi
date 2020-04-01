
{******************************************}
{                                          }
{              FastReport v6.0             }
{            BoxCom Save Filter            }
{                                          }
{            Copyright (c) 2017            }
{             by Oleg Adibekov,            }
{             Fast Reports Inc.            }
{                                          }
{******************************************}

unit frxIOTransportBoxComBase;

interface

{$I frx.inc}

uses
  Classes, Forms, Controls, StdCtrls, ComCtrls,
  frxIOTransportHelpers, frxBaseTransportConnection;

const
  frx_BoxCom_CreateDir_URL = 'https://api.box.com/2.0/folders';
  frx_BoxCom_DelFile_URL = 'https://api.box.com/2.0/files/%s';
  frx_BoxCom_DelDir_URL = 'https://api.box.com/2.0/folders/%s?recursive=true';
  frx_BoxCom_GetToken_URL = 'https://api.box.com/oauth2/token';
  frx_BoxCom_ListDir_URL = 'https://api.box.com/2.0/folders/%s/items?fields=type,name';
  frx_BoxCom_ListDirContinue_URL = 'https://api.box.com/2.0/folders/%s/items?fields=type,name&offset=%u';
  frx_BoxCom_Upload_URL = 'https://upload.box.com/api/2.0/files/content';

type
  TfrxBoxComIOTransportForm = class(TfrxBaseTransportDialog)
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
  TfrxBaseBoxComIOTransport = class(TfrxHTTPIOTransport)
  protected
    FClientSecret: String;
    FDirStack: TDirStack;
    function FilterSection: String; override;
    procedure DialogDirChange(Name, Id: String; DirItems: TStrings); override;
    procedure DialogDirCreate(Name: String; DirItems: TStrings); override;
    procedure DialogFileDelete(Name, Id: String; DirItems: TStrings); override;
    procedure DialogDirDelete(Name, Id: String; DirItems: TStrings); override;

    function GetListFolder: String; virtual; abstract;
    function GetListFolderContinue(Offset: Integer): String; virtual; abstract;
    procedure CreateFolder(Dir: String); virtual; abstract;
    procedure DeleteFile(Id: String); virtual; abstract;
    procedure DeleteFolder(Id: String); virtual; abstract;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    class function GetDescription: String; override;
    class function TransportDialogClass: TfrxBaseTransportDialogClass; override;
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

const
  // https://docs.box.com/v2.0/reference#authorize
  MY_SECURITY_TOKEN = 'FUyabdy9G81Y';
  // The root folder of a Box account is always represented by the id “0”.
  RootFolderId = '0';

{ TfrxBoxComIOTransportForm }

procedure TfrxBoxComIOTransportForm.FormCreate(Sender: TObject);
begin
  Translate(Self);

  RequiredLabel.Visible := False;
  UseProxyServerCheckBox.Checked := False;

  FAccessToken := '';
  FErrorMessage := '';
end;

procedure TfrxBoxComIOTransportForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_F1 then
    frxResources.Help(Self);
end;


procedure TfrxBoxComIOTransportForm.InitControlsFromFilter(
  TransportFilter: TfrxInternetIOTransport);
var
  aFilter: TfrxBaseBoxComIOTransport;
begin
  inherited;
  aFilter := TfrxBaseBoxComIOTransport(TransportFilter);
  RememberPropertiesCheckBox.Visible := aFilter.UseIniFile;
  if aFilter.UseIniFile then
  begin
    IniLoadEdit(ClientIDEdit);
    IniLoadEdit(ClientSecretEdit);
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

procedure TfrxBoxComIOTransportForm.InitFilterFromDialog(
  TransportFilter: TfrxInternetIOTransport);
var
  aFilter: TfrxBaseBoxComIOTransport;
begin
  aFilter := TfrxBaseBoxComIOTransport(TransportFilter);
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

function TfrxBoxComIOTransportForm.IsFinalURL(URL: String): Boolean;
var
  AuthorizationCode: String;
begin
  AuthorizationCode := CopySubstring(URL, '&code=', '');
  if AuthorizationCode <> ''  then
    FAccessToken := TfrxBaseBoxComIOTransport(FFilter)
      .GetAccessToken(AuthorizationCode, ClientIDEdit.Text,
      ClientSecretEdit.Text, FErrorMessage)
  else
    FErrorMessage := CopySubstring(URL, '&error_description=', '&state=');

  Result := FAccessToken + FErrorMessage <> '';
end;

function TfrxBoxComIOTransportForm.IsGetToken: boolean;
var
  BrowserForm: TBrowserForm;
begin
  Result := (FAccessToken <> '');
  if Result then Exit;
  BrowserForm := TBrowserForm.Create(nil);
  try
    BrowserForm.URL := 'https://account.box.com/api/oauth2/authorize?' +
                       'response_type=code' + '&' +
                       'client_id=' + ClientIDEdit.Text + '&' +
                       'redirect_uri=http://localhost&' +
                       'state=' + MY_SECURITY_TOKEN;
    BrowserForm.OnTestURL := IsFinalURL;

    Result := (BrowserForm.ShowModal = mrOK) and (AccessToken <> '');
  finally
    BrowserForm.Free;
  end;
end;

procedure TfrxBoxComIOTransportForm.OkBClick(Sender: TObject);
// TODO: change for something better
const
  URL = 'https://api.box.com/2.0/folders/%s/items?fields=type,name';
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

  FFilter.TestToken(URL, FAccessToken);
  RequiredLabel.Visible := ModalResult = mrNone;

  if (ModalResult = mrOK) and not IsGetToken then
  begin
    if FErrorMessage <> '' then
      frxErrorMsg(FErrorMessage);
    ModalResult := mrCancel;
  end;
end;

procedure TfrxBoxComIOTransportForm.ProxyPortComboBoxKeyPress(Sender: TObject;
  var Key: Char);
begin
  case Key of
    '0' .. '9': ;
    #8: ;
  else
    Key := #0;
  end;
end;

procedure TfrxBoxComIOTransportForm.RequireIf(L: TLabel; Flag: Boolean;
  MR: integer = mrNone);
begin
  if Flag then
  begin
    L.Font.Style := [fsBold];
    L.Font.Color := clRed;
    ModalResult := MR;
  end;
end;

{ TfrxBoxComIOTransport }

constructor TfrxBaseBoxComIOTransport.Create(AOwner: TComponent);
begin
  inherited;

  FClientSecret := '';

  FDirStack := TDirStack.Create(RootFolderId);
end;

destructor TfrxBaseBoxComIOTransport.Destroy;
begin
  FDirStack.Free;
  inherited;
end;

procedure TfrxBaseBoxComIOTransport.DialogDirChange(Name, Id: String;
  DirItems: TStrings);
begin
  if Name = '..' then
    FDirStack.Pop
  else
    FDirStack.Push(Id);
  GetDirItems(DirItems);
end;

procedure TfrxBaseBoxComIOTransport.DialogDirCreate(Name: String;
  DirItems: TStrings);
begin
  CreateFolder(Name);
  GetDirItems(DirItems);
end;

procedure TfrxBaseBoxComIOTransport.DialogDirDelete(Name, Id: String;
  DirItems: TStrings);
begin
  DeleteFolder(Id);
  GetDirItems(DirItems);
end;

procedure TfrxBaseBoxComIOTransport.DialogFileDelete(Name, Id: String;
  DirItems: TStrings);
begin
  DeleteFile(Id);
  GetDirItems(DirItems);
end;

function TfrxBaseBoxComIOTransport.FilterSection: String;
begin
  Result := 'BoxComFilter';
end;

class function TfrxBaseBoxComIOTransport.GetDescription: String;
begin
  Result := frxResources.Get('BoxComIOTransport');
end;

procedure TfrxBaseBoxComIOTransport.GetDirItems(DirItems: TStrings; aFilter: String);
var
  HasMore: Boolean;
  Offset, TotalCount: integer;

  procedure FillDirItems(frxJSONArray: TfrxJSONArray);
  var
    i: Integer;
  begin
    if FDirStack.Top <> RootFolderId then // Up directory
      AddToDirItems(DirItems, True, False, '..', FDirStack.Top);

    for i := 0 to frxJSONArray.Count - 1 do
      with frxJSONArray.Get(i) do
        try
          AddToDirItems(DirItems,
            ValueByName('type') = 'folder', ValueByName('type') = 'file',
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

    FillDirItems(TfrxJSONArray.Create(frxJSON.ObjectByName('entries')));

    Offset := Offset + StrToInt(frxJSON.ValueByName('limit'));
    TotalCount := StrToInt(frxJSON.ValueByName('total_count'));
    HasMore := Offset < TotalCount;
    frxJSON.Free;
  end;

begin
  DirItems.BeginUpdate;
  ClearWithObjects(DirItems);
  Offset := 0;
  GetJSONList(TfrxJSON.Create(GetListFolder));
  while HasMore do
    GetJSONList(TfrxJSON.Create(GetListFolderContinue(Offset)));
  DirItems.EndUpdate;
end;

class function TfrxBaseBoxComIOTransport.TransportDialogClass: TfrxBaseTransportDialogClass;
begin
  Result := TfrxBoxComIOTransportForm;
end;


end.
