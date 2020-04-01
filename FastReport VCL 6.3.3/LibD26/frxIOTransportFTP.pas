
{******************************************}
{                                          }
{             FastReport v6.0              }
{             FTP Save Filter              }
{                                          }
{          Copyright (c) 2016-2017         }
{             by Oleg Adibekov,            }
{             Fast Reports Inc.            }
{                                          }
{******************************************}

unit frxIOTransportFTP;

interface

{$I frx.inc}

uses
  Classes, Forms, Controls, StdCtrls, ComCtrls,
  frxIOTransportHelpers, frxBaseTransportConnection, frxTransportIndyConnector,
  IdFTP, IdComponent, IdTCPConnection;

type
  TfrxFTPIOTransportForm = class(TfrxBaseTransportDialog)
    CancelB: TButton;
    OkB: TButton;
    RequiredLabel: TLabel;
    RememberPropertiesCheckBox: TCheckBox;
    PageControl: TPageControl;
    GeneralTabSheet: TTabSheet;
    HostLabel: TLabel;
    PortLabel: TLabel;
    UserNameLabel: TLabel;
    PasswordLabel: TLabel;
    RemoteDirLabel: TLabel;
    HostComboBox: TComboBox;
    PortComboBox: TComboBox;
    PasswordEdit: TEdit;
    UserNameEdit: TEdit;
    PassiveCheckBox: TCheckBox;
    RemoteDirComboBox: TComboBox;
    ProxyTabSheet: TTabSheet;
    ProxyPasswordEdit: TEdit;
    ProxyUserNameEdit: TEdit;
    ProxyPortComboBox: TComboBox;
    ProxyHostComboBox: TComboBox;
    ProxyPasswordLabel: TLabel;
    ProxyUserNameLabel: TLabel;
    ProxyPortLabel: TLabel;
    ProxyHostLabel: TLabel;
    ProxyTypeLabel: TLabel;
    ProxyTypeComboBox: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure OkBClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure PortComboBoxKeyPress(Sender: TObject; var Key: Char);
  protected
    procedure InitControlsFromFilter(TransportFilter: TfrxInternetIOTransport); override;
    procedure InitFilterFromDialog(TransportFilter: TfrxInternetIOTransport); override;
  private
    procedure RequireIf(L: TLabel; Flag: Boolean; MR: integer = mrNone);
  public
    { Public declarations }
  end;

  TfrxTransportIndyFTPConnector = class(TfrxTransportIndyConnector)
  protected
    function GetProxyHost: String; override;
    function GetProxyLogin: String; override;
    function GetProxyPassword: String; override;
    function GetProxyPort: Integer; override;
    procedure SetProxyHost(const Value: String); override;
    procedure SetProxyLogin(const Value: String); override;
    procedure SetProxyPassword(const Value: String); override;
    procedure SetProxyPort(const Value: Integer); override;
  public
    procedure SetDefaultParametersWithToken(AToken: String); override;
  end;

{$IFDEF DELPHI16}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64)]
{$ENDIF}
  TfrxFTPIOTransport = class(TfrxInternetIOTransport)
  private
    FHost: String;
    FPort: integer;
    FUserName: String;
    FPassword: String;
    FPassive: Boolean;
    FProxyType: TIdFtpProxyType;
    FRemoteDir: String;

    procedure FTPDeleteFile(Name: String);
    procedure FTPDeleteFolder(Name: String);

    procedure FTPSetHost;
    procedure FTPSetProxy;
  protected
    FFTP: TidFTP;
    FConnector: TfrxTransportIndyFTPConnector;

    function Connection: TfrxBaseTransportConnection; override;
    function FilterSection: String; override;
    procedure DialogDirChange(Name, Id: String; DirItems: TStrings); override;
    procedure DialogDirCreate(Name: String; DirItems: TStrings); override;
    procedure DialogFileDelete(Name, Id: String; DirItems: TStrings); override;
    procedure DialogDirDelete(Name, Id: String; DirItems: TStrings); override;
    function CreateConnector: Boolean; override;
    procedure DisposeConnector; override;
    function DoConnectorConncet: Boolean; override;
    function DoBeforeSent: Boolean; override;
    procedure Upload(const Source: TStream; DestFileName: String = ''); override;
    procedure Download(const SourceFileName: String; const Source: TStream); override;
    procedure CreateRemoteDir(DirName: String; ChangeDir: Boolean = True); override;
    procedure ChangeDirUP; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    class function GetDescription: String; override;
    procedure GetDirItems(DirItems: TStrings; aFilter: String = ''); override;
    class function TransportDialogClass: TfrxBaseTransportDialogClass; override;
    function GetConnectorInstance: TfrxBaseTransportConnectionClass; override;
  published
    property Host: String read FHost write FHost;
    property Port: integer read FPort write FPort;
    property UserName: String read FUserName write FUserName;
    property Password: String read FPassword write FPassword;
    property Passive: Boolean read FPassive write FPassive;

    property ProxyType: TIdFtpProxyType read FProxyType write FProxyType;

    property RemoteDir: String read FRemoteDir write FRemoteDir;
  end;

implementation

{$R *.dfm}

uses
  Windows, SysUtils, Graphics, frxClass,
  frxMapHelpers, frxRes, frxIOTransportIntDialog,
  IdFTPCommon, idFTPList
{$IfNDef Indy9}
  , IdAllFTPListParsers
{$ENDIF};

const
  DefaultPort = 21;

  ProxyTypeName: array [TIdFtpProxyType] of string = (
    'None', //
    'UserSite', // Send command USER user@hostname - USER after login (see: http://isservices.tcd.ie/internet/command_config.php)
    'Site', // Send command SITE (with logon)
    'Open', // Send command OPEN
    'UserPass', // USER user@firewalluser@hostname / PASS pass@firewallpass
    'Transparent', // First use the USER and PASS command with the firewall username and password, and then with the target host username and password.
{$IfDef INDYFTP10_2005}
    'HttpProxyWithFtp',
    'CustomProxy');
{$Else}
{$IfDef Indy9}
    'HttpProxyWithFtp'); //HTTP Proxy with FTP support. Will be supported in Indy 10
{$Else}
    'UserHostFireWallID', // USER hostuserId@hostname firewallUsername
    'NovellBorder', // Novell BorderManager Proxy
    'HttpProxyWithFtp', // HTTP Proxy with FTP support. Will be supported in Indy 10
    'CustomProxy'); // use OnCustomFTPProxy to customize the proxy login
{$EndIf}
{$EndIf}

{ Functions }

procedure ProxyTypeGetList(List: TStrings);
var
  pt: TIdFtpProxyType;
begin
  List.Clear;
  for pt := Low(TIdFtpProxyType) to High(TIdFtpProxyType) do
    List.Add(ProxyTypeName[pt]);
end;

{ TfrxFTPIOTransportForm }

procedure TfrxFTPIOTransportForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_F1 then
    frxResources.Help(Self);
end;

procedure TfrxFTPIOTransportForm.InitControlsFromFilter(
  TransportFilter: TfrxInternetIOTransport);
var
  aFilter: TfrxFTPIOTransport;
begin
  inherited;
  aFilter := TfrxFTPIOTransport(TransportFilter);
  RememberPropertiesCheckBox.Visible := aFilter.UseIniFile;
  if aFilter.UseIniFile then
  begin
    IniLoadComboBoxWithItems(HostComboBox);
    IniLoadComboBoxWithItems(PortComboBox);
    IniLoadEdit(UserNameEdit);
    IniLoadEdit(PasswordEdit);
    IniLoadCheckBox(PassiveCheckBox);
    IniLoadComboBoxWithItems(RemoteDirComboBox);

    IniLoadComboBox(ProxyTypeComboBox);
    IniLoadComboBoxWithItems(ProxyHostComboBox);
    IniLoadComboBoxWithItems(ProxyPortComboBox);
    IniLoadEdit(ProxyUserNameEdit);
    IniLoadEdit(ProxyPasswordEdit);
  end
  else
  begin
    HostComboBox.Text := aFilter.Host;
    PortComboBox.Text := IntToStr(aFilter.Port);
    UserNameEdit.Text := aFilter.UserName;
    PasswordEdit.Text := aFilter.Password;
    PassiveCheckBox.Checked := aFilter.Passive;
    RemoteDirComboBox.Text := aFilter.RemoteDir;

    ProxyTypeComboBox.ItemIndex := Integer(aFilter.ProxyType);
    ProxyHostComboBox.Text := aFilter.ProxyHost;
    ProxyPortComboBox.Text := IntToStr(aFilter.ProxyPort);
    ProxyUserNameEdit.Text := aFilter.ProxyUserName;
    ProxyPasswordEdit.Text := aFilter.ProxyPassword;
  end;
end;

procedure TfrxFTPIOTransportForm.InitFilterFromDialog(
  TransportFilter: TfrxInternetIOTransport);
var
  aFilter: TfrxFTPIOTransport;
begin
  aFilter := TfrxFTPIOTransport(TransportFilter);
  aFilter.Host := HostComboBox.Text;
  aFilter.Port := StrToIntDef(PortComboBox.Text, DefaultPort);
  aFilter.UserName := UserNameEdit.Text;
  aFilter.Password := PasswordEdit.Text;
  aFilter.Passive := PassiveCheckBox.Checked;
  aFilter.RemoteDir := RemoteDirComboBox.Text;
  aFilter.ProxyType := TIdFtpProxyType(ProxyTypeComboBox.ItemIndex);
  aFilter.ProxyHost := ProxyHostComboBox.Text;
  aFilter.ProxyPort := StrToIntDef(ProxyPortComboBox.Text, aFilter.DefaultProxyPort);
  aFilter.ProxyUserName := ProxyUserNameEdit.Text;
  aFilter.ProxyPassword := ProxyPasswordEdit.Text;

  if aFilter.UseIniFile then
  begin
    IniSaveComboBoxItem(HostComboBox);
    IniSaveComboBoxItem(PortComboBox);
    IniSaveComboBoxItem(RemoteDirComboBox);
    IniSaveComboBoxItem(ProxyHostComboBox);
    IniSaveComboBoxItem(ProxyPortComboBox);

    if RememberPropertiesCheckBox.Checked then
    begin
      IniSaveComboBox(HostComboBox);
      IniSaveComboBox(PortComboBox);
      IniSaveEdit(UserNameEdit);
      IniSaveEdit(PasswordEdit);
      IniSaveCheckBox(PassiveCheckBox);
      IniSaveComboBox(RemoteDirComboBox);
      IniSaveComboBox(ProxyTypeComboBox);
      IniSaveComboBox(ProxyHostComboBox);
      IniSaveComboBox(ProxyPortComboBox);
      IniSaveEdit(ProxyUserNameEdit);
      IniSaveEdit(ProxyPasswordEdit);
    end;
  end;
  inherited;
end;

procedure TfrxFTPIOTransportForm.FormCreate(Sender: TObject);
begin
  Translate(Self);

  RememberPropertiesCheckBox.Checked := False;
  RequiredLabel.Visible := False;

  ProxyTypeGetList(ProxyTypeComboBox.Items);
  ProxyTypeComboBox.ItemIndex := 0;
end;

procedure TfrxFTPIOTransportForm.OkBClick(Sender: TObject);
var
  HostRequired, UserNameRequired, ProxyHostRequired: Boolean;
begin
  ClearLabelsFontStyle(Self);

  RequireIf(RequiredLabel, True, mrOK);

  HostRequired := HostComboBox.Text = '';
  RequireIf(HostLabel, HostRequired);
  UserNameRequired := UserNameEdit.Text = '';
  RequireIf(UserNameLabel, UserNameRequired);

  ProxyHostRequired := (ProxyTypeComboBox.ItemIndex <> Integer(fpcmNone))
                   and (ProxyHostComboBox.Text = '');
  RequireIf(ProxyHostLabel, ProxyHostRequired);

  if HostRequired or UserNameRequired then
    PageControl.ActivePage := GeneralTabSheet
  else if ProxyHostRequired then
    PageControl.ActivePage := ProxyTabSheet;

  RequiredLabel.Visible := ModalResult = mrNone;
end;

procedure TfrxFTPIOTransportForm.PortComboBoxKeyPress(Sender: TObject;
  var Key: Char);
begin
  case Key of
    '0' .. '9': ;
    #8: ;
  else
    Key := #0;
  end;
end;

procedure TfrxFTPIOTransportForm.RequireIf(L: TLabel; Flag: Boolean;
  MR: integer = mrNone);
begin
  if Flag then
  begin
    L.Font.Style := [fsBold];
    L.Font.Color := clRed;
    ModalResult := MR;
  end;
end;

{ TfrxFTPIOTransport }

procedure TfrxFTPIOTransport.ChangeDirUP;
begin
  FFTP.ChangeDirUp;
end;

function TfrxFTPIOTransport.Connection: TfrxBaseTransportConnection;
begin
  Result := FConnector;
end;

constructor TfrxFTPIOTransport.Create(AOwner: TComponent);
begin
  inherited;

  FHost := '';
  FPort := DefaultPort;
  FUserName := '';
  FPassword := '';
  FPassive := True;
  FRemoteDir := '';
  FDefaultProxyPort := 8080;
  FProxyType := fpcmNone;
  FProxyHost := '';
  FProxyPort := DefaultProxyPort;
  FProxyUserName := '';
  FProxyPassword := '';
  FFTP := nil;
end;

function TfrxFTPIOTransport.CreateConnector: Boolean;
begin
  if not Assigned(FFTP) then
  begin
    FFTP := TidFTP.Create(nil);
    FConnector := TfrxTransportIndyFTPConnector(GetConnectorInstance.NewInstance);
    FConnector.Create(nil);
    FConnector.IdConnection := FFTP;
  end;
  Result := FFTP <> nil;
end;

procedure TfrxFTPIOTransport.CreateRemoteDir(DirName: String;
  ChangeDir: Boolean);
begin
  FFTP.MakeDir(DirName);
  if ChangeDir then
    FFTP.ChangeDir(DirName);
end;

destructor TfrxFTPIOTransport.Destroy;
begin
  FreeAndNil(FConnector);
  inherited;
end;

procedure TfrxFTPIOTransport.DialogDirChange(Name, Id: String; DirItems: TStrings);
begin
  FFTP.TransferType := ftASCII;
  if Name = '..' then
    FFTP.ChangeDirUp
  else
    FFTP.ChangeDir(Name);
  GetDirItems(DirItems);
end;

procedure TfrxFTPIOTransport.DialogDirCreate(Name: String; DirItems: TStrings);
begin
  FFTP.TransferType := ftASCII;
  FFTP.MakeDir(Name);
  GetDirItems(DirItems);
end;

procedure TfrxFTPIOTransport.DialogDirDelete(Name, Id: String;
  DirItems: TStrings);
begin
  FTPDeleteFolder(Name);
  GetDirItems(DirItems);
end;

procedure TfrxFTPIOTransport.DialogFileDelete(Name, Id: String;
  DirItems: TStrings);
begin
  FTPDeleteFile(Name);
  GetDirItems(DirItems);
end;

procedure TfrxFTPIOTransport.DisposeConnector;
begin
  if Assigned(FFTP) then
    FreeAndNil(FFTP);
end;

function TfrxFTPIOTransport.DoBeforeSent: Boolean;
begin
  Result := Inherited DoBeforeSent;
  FFTP.TransferType := ftBinary;
  FFTP.TransferMode(dmStream);
end;

function TfrxFTPIOTransport.DoConnectorConncet: Boolean;
begin
{ TODO: Remote Dir}
////      if RemoteDir <> '' then
////        FFTP.ChangeDir(RemoteDir);
//      DoBeforeSent;
//      for i := 1 to Length(aFullFileLink) do
//        if aFullFileLink[i] = '\' then
//          aFullFileLink[i] := '/';
  Result := True;
  if FFTP.Connected then Exit;
  FTPSetHost;
  FTPSetProxy;
  try
    FFTP.Connect;
  except
    Result := False;
  end;
end;

procedure TfrxFTPIOTransport.Download(const SourceFileName: String;
  const Source: TStream);
begin
  FFTP.Get(SourceFileName, Source, False);
end;

function TfrxFTPIOTransport.FilterSection: String;
begin
  Result := 'FtpFilter';
end;

procedure TfrxFTPIOTransport.FTPDeleteFile(Name: String);
begin
  FFTP.Delete(Name);
end;

procedure TfrxFTPIOTransport.FTPDeleteFolder(Name: String);
var
  DL: TStringList;
  i: Integer;
begin
  DL := TStringList.Create;
  FFTP.ChangeDir(Name);
  FFTP.List(DL, '', false);
  for i := 0 to DL.Count-1 do
    if FFTP.Size(DL.Strings[i]) <> -1 then // Delete file
      FFTP.Delete(DL.Strings[i])
    else if (DL.Strings[i] <> '.') and (DL.Strings[i] <> '..') then // Recursion
      FTPDeleteFolder(DL.Strings[i]);
  FFTP.ChangeDirUp;
  FFTP.RemoveDir(Name); // Delete emptied folder
  DL.Free;
end;

procedure TfrxFTPIOTransport.GetDirItems(DirItems: TStrings; aFilter: String);
var
  i: Integer;
begin
  DirItems.BeginUpdate;
  ClearWithObjects(DirItems);
  FFTP.TransferType := ftASCII;
  FFTP.List(nil);
  for i := 0 to FFTP.DirectoryListing.Count - 1 do
    with FFTP.DirectoryListing[i] do
      if       ItemType = ditFile then
        DirItems.Add(TfrxIOTransportDialogIntForm.AsFile(FileName))
      else if (ItemType = ditDirectory) and (FileName <> '.') then
        DirItems.Add(TfrxIOTransportDialogIntForm.AsDirectory(FileName));
  DirItems.EndUpdate;
end;

procedure TfrxFTPIOTransport.FTPSetHost;
begin
  FFTP.Host := Host;
  FFTP.Port := Port;
  FFTP.UserName := UserName;
  FFTP.Password := Password;
  FFTP.Passive := Passive;
end;

procedure TfrxFTPIOTransport.FTPSetProxy;
begin
  FFTP.ProxySettings.ProxyType := ProxyType;
  if ProxyType <> fpcmNone then
  begin
    FFTP.ProxySettings.Host := ProxyHost;
    FFTP.ProxySettings.Port := ProxyPort;
    FFTP.ProxySettings.UserName := ProxyUserName;
    FFTP.ProxySettings.Password := ProxyPassword;
  end;
end;

function TfrxFTPIOTransport.GetConnectorInstance: TfrxBaseTransportConnectionClass;
begin
  Result := TfrxTransportIndyFTPConnector;
end;

class function TfrxFTPIOTransport.GetDescription: String;
begin
  Result := frxResources.Get('FTPIOTransport');
end;

class function TfrxFTPIOTransport.TransportDialogClass: TfrxBaseTransportDialogClass;
begin
  Result := TfrxFTPIOTransportForm;
end;

procedure TfrxFTPIOTransport.Upload(const Source: TStream; DestFileName: String);
begin
  FFTP.Put(Source, DestFileName);
end;

{ TfrxTransportIndyFTPConnector }

function TfrxTransportIndyFTPConnector.GetProxyHost: String;
begin
  Result := TidFTP(FIdConnection).ProxySettings.Host;
end;

function TfrxTransportIndyFTPConnector.GetProxyLogin: String;
begin
  Result := TidFTP(FIdConnection).ProxySettings.UserName;
end;

function TfrxTransportIndyFTPConnector.GetProxyPassword: String;
begin
  Result := TidFTP(FIdConnection).ProxySettings.Password;
end;

function TfrxTransportIndyFTPConnector.GetProxyPort: Integer;
begin
  Result := TidFTP(FIdConnection).ProxySettings.Port;
end;

procedure TfrxTransportIndyFTPConnector.SetDefaultParametersWithToken(
  AToken: String);
begin
//
end;

procedure TfrxTransportIndyFTPConnector.SetProxyHost(const Value: String);
begin
  TidFTP(FIdConnection).ProxySettings.Host := Value;
end;

procedure TfrxTransportIndyFTPConnector.SetProxyLogin(const Value: String);
begin
  TidFTP(FIdConnection).ProxySettings.UserName := Value;
end;

procedure TfrxTransportIndyFTPConnector.SetProxyPassword(const Value: String);
begin
  TidFTP(FIdConnection).ProxySettings.Password := Value;
end;

procedure TfrxTransportIndyFTPConnector.SetProxyPort(const Value: Integer);
begin
  TidFTP(FIdConnection).ProxySettings.Port := Value;
end;

end.
