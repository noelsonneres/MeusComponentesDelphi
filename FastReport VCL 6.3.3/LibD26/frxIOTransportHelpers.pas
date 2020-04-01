
{******************************************}
{                                          }
{              FastReport v6.0             }
{            Save Filter Helpers           }
{                                          }
{          Copyright (c) 2016-2017         }
{             by Oleg Adibekov,            }
{             Fast Reports Inc.            }
{                                          }
{******************************************}

unit frxIOTransportHelpers;

interface

{$I frx.inc}

uses
  frxClass, frxProgress, Classes, IniFiles, Controls, Forms, StdCtrls,
  frxBaseTransportConnection;

type

  TfrxInternetIOTransport = class;

  TfrxBaseTransportDialog = class(TForm)
  protected
    FIni: TCustomIniFile;
    FFilter: TfrxInternetIOTransport;
    function GetIniFile(TransportFilter: TfrxInternetIOTransport): TCustomIniFile;
    procedure InitDialog; virtual;
    procedure InitControlsFromFilter(TransportFilter: TfrxInternetIOTransport); virtual;
    procedure InitFilterFromDialog(TransportFilter: TfrxInternetIOTransport); virtual;

    function Decode64(Text: String): String;
    function Encode64(Text: String): String;
    procedure IniLoadComboBox(ComboBox: TComboBox);
    procedure IniLoadComboBoxWithItems(ComboBox: TComboBox);
    procedure IniLoadEdit(Edit: TEdit);
    procedure IniLoadCheckBox(CheckBox: TCheckBox);
    procedure IniSaveComboBoxItem(ComboBox: TComboBox);
    procedure IniSaveComboBox(ComboBox: TComboBox);
    procedure IniSaveEdit(Edit: TEdit);
    procedure IniSaveCheckBox(CheckBox: TCheckBox);
  public
    destructor Destroy; override;
  end;

  TfrxBaseTransportDialogClass = class of TfrxBaseTransportDialog;

  TfrxInternetIOTransport = class(TfrxCustomIOTransport)
  private
    FUseIniFile: Boolean;
    FShowProgress: Boolean;
    procedure ConnectionWorkBegin(Sender: TObject; AWorkMode: TfrxHTTPWorkMode; AWorkCount: Int64);
    procedure ConnectionWork(Sender: TObject; AWorkMode: TfrxHTTPWorkMode; AWorkCount: Int64);
  protected
    FIsFilterOpened: Boolean;
    FProgress: TfrxProgress;
    FWorkBeginPosition: Int64;
    FDefaultProxyPort: Integer;
    FProxyHost: String;
    FProxyPort: integer;
    FProxyUserName: String;
    FProxyPassword: String;
    FUserName: String;
    FPassword: String;
    function Connection: TfrxBaseTransportConnection; virtual; abstract;
    function FormShowModal: TModalResult;
    procedure CreateProgress(ProgressCaption: String);

    function FilterSection: String; virtual; abstract;
    function PropertiesSection: String;
    procedure ProcessFiles;

    function SizeOfFiles: Int64;
    function IsSelectFileName: Boolean;
    function IsSelectDirectory: Boolean;
    function SendFiles: String;

    function DoCreateStream(var aFullFilePath: String; aFileName: String): TStream; override;

    { connector }
    { initialize connector - called before sending files }
    function CreateConnector: Boolean; virtual; abstract;
    { free connector }
    procedure DisposeConnector; virtual; abstract;
    { establish connection  }
    function DoConnectorConncet: Boolean; virtual; abstract;
    { prepare connection for file sending }
    function DoBeforeSent: Boolean; virtual;
    { send file stream }
    procedure Upload(const Source: TStream; DestFileName: String = ''); virtual; abstract;
    procedure Download(const SourceFileName: String; const Source: TStream); virtual;
    { creates remote directory }
    procedure CreateRemoteDir(DirName: String; ChangeDir: Boolean = True); virtual;
    { change current directory to parent }
    procedure ChangeDirUP; virtual;

    function IsDeleteSupported: Boolean; virtual;

    { Dialog callback's }
    procedure DialogDirChange(Name, Id: String; DirItems: TStrings); virtual; abstract;
    procedure DialogDirCreate(Name: String; DirItems: TStrings); virtual; abstract;
    procedure DialogDirDelete(Name, Id: String; DirItems: TStrings); virtual; abstract;
    procedure DialogFileDelete(Name, Id: String; DirItems: TStrings); virtual; abstract;
  public
    constructor Create(AOwner: TComponent); override;
    procedure AssignFilter(Source: TfrxCustomIOTransport); override;
    function OpenFilter: Boolean; override;
    procedure CloseFilter; override;
    { get directory items }
    function GetConnectorInstance: TfrxBaseTransportConnectionClass; virtual; abstract;
    procedure GetDirItems(DirItems: TStrings; aFilter: String = ''); virtual; abstract;
    class function TransportDialogClass: TfrxBaseTransportDialogClass; virtual;
    procedure TestToken(const URL: String; var sToken: String; bUsePOST: Boolean = False); virtual;
  published
    property UseIniFile: Boolean read FUseIniFile write FUseIniFile;
    property ShowProgress: Boolean read FShowProgress write FShowProgress;
    property DefaultProxyPort: Integer read FDefaultProxyPort;
    property ProxyHost: String read FProxyHost write FProxyHost;
    property ProxyPort: integer read FProxyPort write FProxyPort;
    property ProxyUserName: String read FProxyUserName write FProxyUserName;
    property ProxyPassword: String read FProxyPassword write FProxyPassword;
    property UserName: String read FUserName write FUserName;
    property Password: String read FPassword write FPassword;
  end;

  TfrxHTTPIOTransport = class(TfrxInternetIOTransport)
  private
    FClientID: String;
    FUseProxyServer: Boolean;
    FConnected: Boolean;
  protected
    FHTTP: TfrxBaseTransportConnection;
    FAccessToken: String;
    FRemoteDir: String;
    FAccessTokens: TStrings;
    function Connection: TfrxBaseTransportConnection; override;
    procedure SetProxy;
    procedure Upload(const Source: TStream; DestFileName: String = ''); override;
    procedure ChangeDirUP; override;
    procedure TestRemoteDir; virtual; // Empty
    function CreateConnector: Boolean; override;
    procedure DisposeConnector; override;
    function DoConnectorConncet: Boolean; override;
    procedure AddToDirItems(DirItems: TStrings; IsFolder, IsFile: Boolean;
      Name: String; Id: String = '');
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AssignSharedProperties(Source: TfrxCustomIOTransport); override;
    procedure AssignFilter(Source: TfrxCustomIOTransport); override;
    property AccessToken: String read FAccessToken write FAccessToken;
  published
    property ClientID: String read FClientID write FClientID;
    property UseProxyServer: Boolean read FUseProxyServer write FUseProxyServer;
  end;

  TIdObject = class
  private
    FId: String;
  public
    constructor Create(AId: String);
    property Id: String read FId;
  end;

  TDirStack = class
  private
    StringList: TStringList;
  public
    constructor Create(st: String);
    destructor Destroy; override;

    procedure Push(st: String);
    function Pop: String;
    function Top: String;
  end;

procedure ClearLabelsFontStyle(Form: TForm);
function CopySubstring(Source, Left, Right: String): String;
function JsonEncode(str: String): String;
function SureUTF8(str: String): String;
function SureAnsi(str: String): AnsiString;
function PathFirstSlash(const Path: String): String;
function PathChangeDir(const Path, Dir: String): String;
procedure ClearWithObjects(DirItems: TStrings);

implementation

uses
  Registry, SysUtils, Graphics, StrUtils,
  frxNetUtils, frxFileUtils, frxUtils, frxIOTransportIntDialog, frxRes;

{ Functions }

procedure ClearWithObjects(DirItems: TStrings);
var
  i: Integer;
begin
  for i := 0 to DirItems.Count - 1 do
    DirItems.Objects[i].Free;
  DirItems.Clear;
end;

function PathChangeDir(const Path, Dir: String): String;
var
  i: integer;
begin
  if Dir = '..' then
  begin
    i := Length(Path);
    if Path[i] = '/' then Dec(i);
    while Path[i] <> '/' do
      Dec(i);
    Result := Copy(Path, 1, i - 1);
  end
  else
    Result := Path + '/' + Dir;
end;

function PathFirstSlash(const Path: String): String;
begin
  if (Path <> '') and (Path[1] <> '/') then
    Result := '/' + Path
  else
    Result := Path;
end;

function SureAnsi(str: String): AnsiString;
begin
{$IfDef Delphi12} Result := AnsiString(Utf8Encode(str));
{$Else}           Result := str;
{$EndIf}
end;

function SureUTF8(str: String): String;
begin
{$IfDef Delphi12} Result := str;
{$Else}           Result := AnsiToUtf8(str);
{$EndIf}
end;

function JsonEncode(str: String): String;
var
  i: Integer;
begin
  Result := '';
  for i := 1 to Length(str) do
    if Ord(WideString(str[i])[1]) > 127 then
      Result := Result + '\u' + Format('%.4x', [Ord(WideString(str[i])[1])])
    else
      Result := Result + str[i];
end;

// Left = '' => LineStart; Right = '' => LineEnd
function CopySubstring(Source, Left, Right: String): String;
var
  PosLeft, PosRight, PosStart: Integer;
begin
  Result := '';
  PosLeft := IfInt(Left = '', 1, Pos(Left, Source));
  if PosLeft > 0 then
  begin
    PosStart := PosLeft + Length(Left);
    PosRight := IfInt(Right = '', Length(Source) + 1, Pos(Right, Source));
    if PosRight > PosStart then
      Result := Copy(Source, PosStart, PosRight - PosStart);
  end;
end;

procedure ClearLabelsFontStyle(Form: TForm);
var
  i: integer;
begin
  with Form do
    for i := 0 to ComponentCount - 1 do
      if Components[i] is TLabel then
        with TLabel(Components[i]) do
        begin
          Font.Style := [];
          Font.Color := clWindowText;
        end;
end;

{ TfrxInternetIOTransport }

procedure TfrxInternetIOTransport.AssignFilter(Source: TfrxCustomIOTransport);
var
  lFilter: TfrxInternetIOTransport;
begin
  inherited;
  if Source is TfrxInternetIOTransport then
  begin
    lFilter := TfrxInternetIOTransport(Source);
    FDefaultProxyPort := lFilter.FDefaultProxyPort;
    FProxyHost := lFilter.FProxyHost;
    FProxyPort := lFilter.FProxyPort;
    FProxyUserName := lFilter.FProxyUserName;
    FProxyPassword := lFilter.FProxyPassword;
    FUserName := lFilter.FUserName;
    FPassword := lFilter.FPassword;
    FShowProgress := lFilter.FShowProgress
  end;
end;

procedure TfrxInternetIOTransport.ChangeDirUP;
begin

end;

procedure TfrxInternetIOTransport.CloseFilter;
var
  SendError: String;
begin
  if not FIsFilterOpened Then Exit;
  try
    if FilterAccess <> faRead then
      SendError := IfStr(FIsFilterOpened, SendFiles);
  finally
    inherited;
  end;
  if (SendError <> '') and (Report <> nil) then
    case Report.EngineOptions.NewSilentMode of
      simSilent:
        Report.Errors.Add(SendError);
      simMessageBoxes:
        frxErrorMsg(SendError);
      simReThrow:
        raise Exception.Create(SendError);
    end;
end;

procedure TfrxInternetIOTransport.ConnectionWork(Sender: TObject; AWorkMode: TfrxHTTPWorkMode; AWorkCount: Int64);
begin
  if FProgress.Terminated then
  begin
    Connection.OnWorkBegin := nil;
    Connection.OnWork := nil;
    Connection.OnWorkEnd := nil;
    Connection.Disconnect;
  end
  else if AWorkMode = hwmWrite then
    FProgress.Position := FWorkBeginPosition + AWorkCount;
end;

procedure TfrxInternetIOTransport.ConnectionWorkBegin(Sender: TObject; AWorkMode: TfrxHTTPWorkMode; AWorkCount: Int64);
begin
  if AWorkMode = hwmWrite then
    FWorkBeginPosition := FProgress.Position;
end;

constructor TfrxInternetIOTransport.Create(AOwner: TComponent);
begin
  inherited;
  FUseIniFile := True;
  FShowProgress := True;
  FProgress := nil;
  ShowDialog := True;
end;

procedure TfrxInternetIOTransport.CreateProgress(ProgressCaption: String);
begin
  if ShowProgress and ShowDialog then
  begin
    FProgress := TfrxProgress.Create(nil);
    FProgress.Execute(SizeOfFiles, ProgressCaption,
      { Canceled: } True, { Progress: } True);
    Connection.OnWorkBegin := ConnectionWorkBegin;
    Connection.OnWork := ConnectionWork;
  end
  else
    FProgress := nil;
end;

procedure TfrxInternetIOTransport.CreateRemoteDir(DirName: String;
  ChangeDir: Boolean);
begin

end;

function TfrxInternetIOTransport.FormShowModal: TModalResult;
var
  fDialog: TfrxBaseTransportDialog;
begin
  if not ShowDialog then
  begin
    Result := mrOK;
    Exit;
  end;
  fDialog := TfrxBaseTransportDialog(TransportDialogClass.NewInstance);
  fDialog.Create(nil);
  try
    fDialog.InitControlsFromFilter(Self);
    Result := fDialog.ShowModal;
    if Result = mrOK then
    begin
      fDialog.InitFilterFromDialog(Self);
    end;
  finally
    fDialog.Free;
  end;
end;

function TfrxInternetIOTransport.DoBeforeSent: Boolean;
begin
  Result := True;
end;

function TfrxInternetIOTransport.DoCreateStream(var aFullFilePath: String; aFileName: String): TStream;
var
  fName: String;
  i: Integer;
  OldFilterAccess: TfrxFilterAccess;
begin
  Result := nil;
  fName := aFullFilePath;
  i := PosEx(BasePath, fName, 1);
  if i = 1 then
    fName := Copy(fName, Length(BasePath), Length(fName));

  // if ExtractFilePath(aFileName) = '' then
  // fName := GetTempFile + ExtractFileExt(aFileName);

  if (fName = '') and (FilterAccess = faRead) then
    if IsSelectFileName then
      fName := Filename;

  if (fName <> '') then
  begin
    OldFilterAccess := FilterAccess;
    FilterAccess := faWrite;
    InternalFilter.FilterAccess := faWrite;
    InternalFilter.CreateTempContainer;
    Result := InternalFilter.GetStream(InternalFilter.BasePath + PathDelim +
      fName); // TFileStream.Create(fName, fmCreate);
    FilterAccess := OldFilterAccess;
  end;

  if FilterAccess = faRead then
  begin
    { TODO: Move to Filter.Open }
    if aFullFilePath = '' then
    begin
      aFullFilePath := fName;
      aFileName := fName;
    end;
   // DoReadRemoteContent(aFullFilePath, Result);
    if Result = nil then
      Exit;
    Download(aFullFilePath, Result);
    InternalFilter.FreeStream(Result);
    OldFilterAccess := InternalFilter.FilterAccess;
    InternalFilter.FilterAccess := faRead;
    Result := InternalFilter.GetStream(InternalFilter.BasePath +
      PathDelim + fName);
    InternalFilter.FilterAccess := OldFilterAccess;
  end;
end;

procedure TfrxInternetIOTransport.Download(const SourceFileName: String;
  const Source: TStream);
begin

end;

function TfrxInternetIOTransport.IsDeleteSupported: Boolean;
begin
  Result := False;
end;

function TfrxInternetIOTransport.IsSelectDirectory: Boolean;
begin
  Result := True;
  if not ShowDialog then Exit;
  with TfrxIOTransportDialogIntForm.Create(nil) do
    try
      DialogMode := idmDir;
      if not IsDeleteSupported then
        DisableDelete;
      OnDirChange := DialogDirChange;
      OnDirCreate := DialogDirCreate;
      OnDirDelete := DialogDirDelete;
      OnFileDelete := DialogFileDelete;

      //GetDirItems(DirItems);
      IOTransport := Self;
      Result := ShowModal = mrOK;
    finally
      Free;
    end;
end;

function TfrxInternetIOTransport.IsSelectFileName: Boolean;
var
  fNode: TfrxNode;
begin
  Result := False;
  if not CreateConnector or not DoConnectorConncet then Exit;
  Result := True;
  if not ShowDialog then Exit;
  with TfrxIOTransportDialogIntForm.Create(nil) do
    try
      if FilterAccess = faWrite then
        DialogMode := idmSave
      else
        DialogMode := idmOpen;
      if not IsDeleteSupported then
        DisableDelete;
      OnDirChange := DialogDirChange;
      OnDirCreate := DialogDirCreate;
      OnDirDelete := DialogDirDelete;
      OnFileDelete := DialogFileDelete;

      //GetDirItems(DirItems);
      IOTransport := Self;
      fNode := GetFileNode;

      if fNode <> nil then
        DialogFileName := fNode.Name
      else
        DialogFileName := FileName;
      //ExtractFileName(FFiles.Names[0]);
      Result := ShowModal = mrOK;
      if Result then
        if fNode <> nil then
          fNode.Name := DialogFileName
        else
        begin
          FileName := DialogFileName;
        end;
    finally
      Free;
    end;
end;

function TfrxInternetIOTransport.OpenFilter: Boolean;
begin
  FIsFilterOpened := (FormShowModal = mrOK);
  if (FilterAccess = faRead) and FIsFilterOpened then
    FIsFilterOpened := (SendFiles = '');
  Result := FIsFilterOpened;
end;

function TfrxInternetIOTransport.PropertiesSection: String;
begin
  Result := FilterSection + '.Properties';
end;

procedure TfrxInternetIOTransport.ProcessFiles;

  procedure DoItem(aItem: TfrxNode);
  var
    lItem: tfrxNode;
    i: Integer;
//    sName: String;
  begin
    for i := 0 to aItem.Count - 1 do
    begin
      lItem := aItem.Items[i];
      if Assigned(FProgress) and FProgress.Terminated then Exit;
      if Assigned(lItem.ObjectData) then
      begin
        Upload(TStream(lItem.ObjectData), lItem.Name);
//        FSendedTotal := FSendedTotal + TStream(lItem.ObjectData).Size;
      end
      else
        if aItem.OriginalName = '' then
        begin
          CreateRemoteDir(lItem.Name);
          DoItem(lItem);
          ChangeDirUp;
        end;
    end;
  end;

begin
  DoBeforeSent;
  if (RootNode.Count = 0) and (FilterAccess = faRead) then
    GetStream(FileName)
  else
    DoItem(InternalFilter.RootNode);
end;

function TfrxInternetIOTransport.SendFiles: String;
var
  sMessage: String;
begin
  Result := '';
  if not CreateConnector then Exit; // TODO: rise exception later
  try
    try
      if DoConnectorConncet then
      if ((FDirTree.FilesCount = 1) or (FilterAccess = faRead)) and IsSelectFileName or
         (FDirTree.FilesCount > 1) and IsSelectDirectory then
      begin
        if FilterAccess = faWrite then
        begin
          InternalFilter.FilterAccess := faRead;
          InternalFilter.CloseAllStreams;
          InternalFilter.LoadClosedStreams;
        end;
        if FilterAccess = faWrite then
          sMessage := GetStr('IOTransportUploading')
        else
          sMessage := GetStr('IOTransportDownloading');
        CreateProgress(sMessage + ' ' + GetDescription);
        ProcessFiles;
      end
      else
      begin
        Result := 'Closed';// TODO
        FIsFilterOpened := False;
      end;
    except
      on e: Exception do
        Result := IfStr(e.Message = '', 'Empty HTTP Error', e.Message);
    end;
  finally
    FreeAndNil(FProgress);
    DisposeConnector;
  end;
end;


function TfrxInternetIOTransport.SizeOfFiles: Int64;
  function DoSizeOfFiles(aItem: TfrxNode): Int64;
  var
    lItem: tfrxNode;
    i: Integer;
  begin
    Result := 0;
    for i := 0 to aItem.Count - 1 do
    begin
      lItem := aItem.Items[i];
      if lItem.OriginalName = '' then
        Result := Result + DoSizeOfFiles(lItem)
      else
        if Assigned(lItem.ObjectData) then
           Result := Result + TStream(lItem.ObjectData).Size
        else
          Result := Result + frxFileUtils.GetFileSize(lItem.OriginalName);
    end;
  end;
begin
  Result := DoSizeOfFiles(InternalFilter.RootNode);
end;

procedure TfrxInternetIOTransport.TestToken(const URL: String;
  var sToken: String; bUsePOST: Boolean);
begin

end;

class function TfrxInternetIOTransport.TransportDialogClass: TfrxBaseTransportDialogClass;
begin
  Result := TfrxBaseTransportDialog;
end;

{ TfrxHTTPIOTransport }

procedure TfrxHTTPIOTransport.AddToDirItems(DirItems: TStrings; IsFolder,
  IsFile: Boolean; Name: String; Id: String = '');
var
  FullName: String;
begin
  if      IsFolder then
    FullName := TfrxIOTransportDialogIntForm.AsDirectory(Name)
  else if IsFile then
    FullName := TfrxIOTransportDialogIntForm.AsFile(Name);

  if IsFolder or IsFile then
    if Id = '' then
      DirItems.Add(FullName)
    else
      DirItems.AddObject(FullName, TIdObject.Create(Id));
end;

procedure TfrxHTTPIOTransport.AssignFilter(Source: TfrxCustomIOTransport);
var
  lFilter: TfrxHTTPIOTransport;
begin
  inherited;
  if Source is TfrxHTTPIOTransport then
  begin
    lFilter := TfrxHTTPIOTransport(Source);
    FClientID := lFilter.FClientID;
    FUseProxyServer := lFilter.FUseProxyServer;
    FAccessToken := lFilter.FAccessToken;
    FRemoteDir := lFilter.FRemoteDir;
  end;
end;

procedure TfrxHTTPIOTransport.AssignSharedProperties(
  Source: TfrxCustomIOTransport);
var
  tHTTP: TfrxHTTPIOTransport;
  Index: Integer;
begin
  inherited;
  tHTTP := (Source as TfrxHTTPIOTransport);
  if not Assigned(tHTTP) then Exit;

  if not FNoRegister then
  begin
    Index := FAccessTokens.IndexOf(tHTTP.ClientID);
    if Index = -1 then
      FAccessTokens.AddObject(tHTTP.ClientID, TIdObject.Create(tHTTP.FAccessToken))
    else
      TIdObject(FAccessTokens.Objects[Index]).FId := tHTTP.FAccessToken;
  end;

  Index := tHTTP.FAccessTokens.IndexOf(ClientID);
  if Index > -1 then
    FAccessToken := TIdObject(tHTTP.FAccessTokens.Objects[Index]).Id;
end;

procedure TfrxHTTPIOTransport.ChangeDirUP;
var
  i: Integer;
begin
  for i := Length(FRemoteDir) downto 1 do
    if FRemoteDir[i] = '/' then
    begin
      FRemoteDir := Copy(FRemoteDir, 1, Length(FRemoteDir) - (Length(FRemoteDir) - i));
      if FRemoteDir = '/' then FRemoteDir := '';
      Exit;
    end;
end;


function TfrxHTTPIOTransport.Connection: TfrxBaseTransportConnection;
begin
  Connection := FHTTP;
end;

constructor TfrxHTTPIOTransport.Create(AOwner: TComponent);
begin
  inherited;
  FConnected := False;
  FClientID := '';
  FDefaultProxyPort := 80;
  FProxyPort := FDefaultProxyPort;
  FUSeProxyServer := False;
  FAccessTokens := TStringList.Create;
end;

function TfrxHTTPIOTransport.CreateConnector: Boolean;
begin
  Result := FHTTP <> nil;
  if Result then Exit;
  FHTTP := TfrxBaseTransportConnection(GetConnectorInstance.NewInstance);
  FHTTP.Create(nil);
  try
    FHTTP.SetDefaultParametersWithToken(FAccessToken);
  finally
    Result := FHTTP <> nil;
  end;
end;

destructor TfrxHTTPIOTransport.Destroy;
begin
  ClearWithObjects(FAccessTokens);
  FreeAndNil(FAccessTokens);
  inherited;
end;

procedure TfrxHTTPIOTransport.DisposeConnector;
begin
  if Assigned(FHTTP) then
    FreeAndNil(FHTTP);
  FConnected := False;
end;

function TfrxHTTPIOTransport.DoConnectorConncet: Boolean;
begin
  if not FConnected then
  begin
    SetProxy;
    TestRemoteDir;
    FConnected := True;
  end;
  Result := FConnected;
end;

procedure TfrxHTTPIOTransport.SetProxy;
begin
  if UseProxyServer then
  begin
    FHTTP.ProxyHost := ProxyHost;
    FHTTP.ProxyPort := ProxyPort;
    FHTTP.ProxyLogin := ProxyUserName;
    FHTTP.ProxyPassword := ProxyPassword;
  end;
end;

procedure TfrxHTTPIOTransport.TestRemoteDir;
begin

end;

procedure TfrxHTTPIOTransport.Upload(const Source: TStream;
  DestFileName: String);
begin

end;

{ TIdObject }

constructor TIdObject.Create(AId: String);
begin
  FId := AId;
end;

{ TDirStack }

constructor TDirStack.Create(st: String);
begin
  StringList := TStringList.Create;
  Push(st);
end;

destructor TDirStack.Destroy;
begin
  StringList.Free;

  inherited;
end;

function TDirStack.Pop: String;
begin
  Result := Top;
  StringList.Delete(StringList.Count - 1);
end;

procedure TDirStack.Push(st: String);
begin
  StringList.Add(st);
end;

function TDirStack.Top: String;
begin
  Result := StringList[StringList.Count - 1];
end;

{ TfrxBaseTransportDialog }

function TfrxBaseTransportDialog.Decode64(Text: String): String;
begin
  Result := String(UTF8Decode(Base64Decode(AnsiString(Text))));
end;

destructor TfrxBaseTransportDialog.Destroy;
begin
  if Assigned(FIni) then
    FreeAndNil(FIni);
  inherited;
end;

function TfrxBaseTransportDialog.Encode64(Text: String): String;
begin
  Result := String(Base64Encode(UTF8Encode(Text)));
end;

function TfrxBaseTransportDialog.GetIniFile(TransportFilter: TfrxInternetIOTransport): TCustomIniFile;
begin
  Result := FIni;
  if Assigned(FIni) then Exit;
  if not TransportFilter.UseIniFile then
    Result := nil
  else if Assigned(TransportFilter.Report) then
    Result := TransportFilter.Report.GetIniFile
  else
    Result := TRegistryIniFile.Create('\Software\Fast Reports');
end;

procedure TfrxBaseTransportDialog.IniLoadCheckBox(CheckBox: TCheckBox);
begin
  CheckBox.Checked := FIni.ReadBool(FFilter.PropertiesSection, CheckBox.Name, False);
end;

procedure TfrxBaseTransportDialog.IniLoadComboBox(ComboBox: TComboBox);
begin
  ComboBox.Text := FIni.ReadString(FFilter.PropertiesSection, ComboBox.Name, '');
end;

procedure TfrxBaseTransportDialog.IniLoadComboBoxWithItems(ComboBox: TComboBox);
begin
  IniLoadComboBox(ComboBox);
  FIni.ReadSection(FFilter.FilterSection + '.' + ComboBox.Name, ComboBox.Items);
end;

procedure TfrxBaseTransportDialog.IniLoadEdit(Edit: TEdit);
begin
  Edit.Text := Decode64(FIni.ReadString(FFilter.PropertiesSection, Edit.Name, ''));
end;

procedure TfrxBaseTransportDialog.IniSaveCheckBox(CheckBox: TCheckBox);
begin
  FIni.WriteBool(FFilter.PropertiesSection, CheckBox.Name, CheckBox.Checked);
end;

procedure TfrxBaseTransportDialog.IniSaveComboBox(ComboBox: TComboBox);
begin
  FIni.WriteString(FFilter.PropertiesSection, ComboBox.Name, ComboBox.Text);
end;

procedure TfrxBaseTransportDialog.IniSaveComboBoxItem(ComboBox: TComboBox);
begin
  FIni.WriteString(FFilter.FilterSection + '.' + ComboBox.Name, ComboBox.Text, '');
end;

procedure TfrxBaseTransportDialog.IniSaveEdit(Edit: TEdit);
begin
  FIni.WriteString(FFilter.PropertiesSection, Edit.Name, Encode64(Edit.Text));
end;

procedure TfrxBaseTransportDialog.InitControlsFromFilter(
  TransportFilter: TfrxInternetIOTransport);
begin
  FFilter := TransportFilter;
  FIni := GetIniFile(TransportFilter);
end;

procedure TfrxBaseTransportDialog.InitDialog;

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
begin
  AssignTexts(Self);
  if UseRightToLeftAlignment then
    FlipChildren(True);
end;

procedure TfrxBaseTransportDialog.InitFilterFromDialog(
  TransportFilter: TfrxInternetIOTransport);
begin
  FFilter := nil;
  if Assigned(FIni) then
    FreeAndNil(FIni);
end;

end.
