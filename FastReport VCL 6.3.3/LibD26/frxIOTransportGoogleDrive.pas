
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

unit frxIOTransportGoogleDrive;

interface

{$I frx.inc}

uses
  Classes, frxIOTransportHelpers, frxBaseTransportConnection, frxIOTransportGoogleDriveBase;

type
{$IFDEF DELPHI16}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64)]
{$ENDIF}
  TfrxGoogleDriveIOTransport = class(TfrxBaseGoogleDriveIOTransport)
  protected
    function GetListFolder(aFilter: String = ''): String; override;
    function GetListFolderContinue(NextPageToken: String; aFilter: String = ''): String; override;
    procedure CreateFolder(Dir: String); override;
    procedure DeleteFileOrFolder(const Id: String); override;
    procedure Upload(const Source: TStream; DestFileName: String = ''); override;
    procedure Download(const SourceFileName: String; const Source: TStream); override;
  public
    function GetAccessToken(AuthorizationCode, ClientId, ClientSecret: String; var ErrorMsg: String): String; override;
    function GetConnectorInstance: TfrxBaseTransportConnectionClass; override;
    procedure TestToken(const URL: String; var sToken: String; bUsePOST: Boolean = False); override;
  end;

implementation

uses
  SysUtils, frxJSON, frxTransportHTTP;

{ TfrxGoogleDriveIOTransport }

procedure TfrxGoogleDriveIOTransport.CreateFolder(Dir: String);
var
  Stream: TStringStream;
  tHTTP: TfrxTransportHTTP;
begin
  tHTTP := TfrxTransportHTTP(FHTTP);
  tHTTP.HTTPRequest.ContentType := 'application/json';
  tHTTP.HTTPRequest.Encoding:='UTF-8';

  Stream := TStringStream.Create(
    Format('{"mimeType": "%s", "name": "%s", "parents": ["%s"]}',
    {$IfDef Delphi12}[frx_GoogleDrive_MimeFolder, Dir, FDirStack.Top]), TEncoding.UTF8);
    {$Else}          [frx_GoogleDrive_MimeFolder, JsonEncode(Dir), FDirStack.Top]));
    {$EndIf}

  try
    tHTTP.Post(frx_GoogleDrive_CreateDir_URL, Stream);
  finally
    Stream.Free;
  end;
end;

procedure TfrxGoogleDriveIOTransport.DeleteFileOrFolder(const Id: String);
begin
  TfrxTransportHTTP(FHTTP).Delete(Format(frx_GoogleDrive_Delete_URL, [Id]));
end;

procedure TfrxGoogleDriveIOTransport.Download(const SourceFileName: String;
  const Source: TStream);
var
  sList: TStringList;
  sID: String;
  Index: Integer;
begin
  inherited;
  sID := '';
  SList := TStringList.Create;
  GetDirItems(SList, SourceFileName);
  Index := sList.IndexOf(SourceFileName);
  if Index = -1 then Exit;
  sID  := TIdObject(sList.Objects[Index]).Id;
  try
    TfrxTransportHTTP(FHTTP).Get(Format(frx_GoogleDrive_Download_URL, [sID]), Source);
  finally
    ClearWithObjects(SList);
    SList.Free;
  end;
end;

function TfrxGoogleDriveIOTransport.GetAccessToken(AuthorizationCode, ClientId,
  ClientSecret: String; var ErrorMsg: String): String;
var
  tHTTP: TfrxTransportHTTP;
  Source: TStringStream;
  Res: String;
  frxJSON: TfrxJSON;
begin
  Source := TStringStream.Create('');
  Source.WriteString('code=' + AuthorizationCode + '&');
  Source.WriteString('client_id=' + ClientId + '&');
  Source.WriteString('client_secret=' + ClientSecret + '&');
  Source.WriteString('redirect_uri=http://localhost&');
  Source.WriteString('grant_type=authorization_code');
  try
    tHTTP := TfrxTransportHTTP.Create(nil);
    try
      tHTTP.HTTPRequest.Encoding := '';
      tHTTP.HTTPRequest.DefAcceptTypes := htcDefaultXML;
      tHTTP.HTTPRequest.ContentType := 'application/x-www-form-urlencoded';
      Res := tHTTP.Post(frx_GoogleDrive_GetToken_URL, Source);
      if Res = '' then
      begin
        ErrorMsg := 'Error: Not connected';
        Exit;
      end;
      frxJSON := TfrxJSON.Create(Res);
      try
        if frxJSON.IsNameExists('access_token') then
          Result := frxJSON.ValueByName('access_token')
        else if frxJSON.IsNameValueExists('type', 'error') then
          ErrorMsg := 'Error: ' + frxJSON.ValueByName('status') + '; ' +
            frxJSON.ValueByName('message')
        else
          ErrorMsg := 'Error: Answer code: ' + IntToStr(tHTTP.ServerFields.AnswerCode) + ' Result: ' + Res;
      finally
        frxJSON.Free;
      end;
    finally
      tHTTP.Free;
    end;
  finally
    Source.Free;
  end;
end;

function TfrxGoogleDriveIOTransport.GetConnectorInstance: TfrxBaseTransportConnectionClass;
begin
  Result := TfrxTransportHTTP;
end;

function TfrxGoogleDriveIOTransport.GetListFolder(aFilter: String): String;
begin
  if aFilter <> '' then
    aFilter := Format('+and+name=''%s''', [aFilter]);
  Result := TfrxTransportHTTP(FHTTP)
    .Get(Format(frx_GoogleDrive_ListDir_URL, [FDirStack.Top, aFilter]));
end;

function TfrxGoogleDriveIOTransport.GetListFolderContinue(NextPageToken: String; aFilter: String): String;
begin
  if aFilter <> '' then
    aFilter := Format('+and+name=''%s''', [aFilter]);
  Result := TfrxTransportHTTP(FHTTP)
    .Get(Format(frx_GoogleDrive_ListDirContinue_URL, [FDirStack.Top, aFilter,
    NextPageToken]));
end;

procedure TfrxGoogleDriveIOTransport.TestToken(const URL: String;
  var sToken: String; bUsePOST: Boolean);
begin
  frxTestToken(URL, sToken, bUsePOST);
end;

procedure TfrxGoogleDriveIOTransport.Upload(const Source: TStream;
  DestFileName: String);
const
  Boundary = '560310243403';
var
  MemoryStream: TMemoryStream;
  tHTTP: TfrxTransportHTTP;

  procedure Put(str: AnsiString);
  begin
    MemoryStream.Write(str[1], Length(str));
  end;

  procedure PutLn(str: AnsiString = '');
  begin
    Put(str + #13#10);
  end;
begin
  inherited;
  tHTTP := TfrxTransportHTTP(FHTTP);
  tHTTP.HTTPRequest.ContentType :=
    AnsiString(Format('multipart/related; boundary="%s"', [Boundary]));
  tHTTP.HTTPRequest.Encoding:='';

  MemoryStream := TMemoryStream.Create;

  PutLn('--' + Boundary);
  PutLn('Content-ID: <metadata>');
  PutLn('Content-Type: application/json');
  PutLn;

  PutLn(SureAnsi(Format(
    '{"name": "%s", "parents": ["%s"]}',
    [SureUTF8(DestFileName), FDirStack.Top])));
  PutLn('--' + Boundary);
  PutLn('Content-ID: <content>');
  PutLn('Content-Type: application/octet-stream');
  PutLn;

  MemoryStream.CopyFrom(Source, Source.Size);

  PutLn;
  Put('--' + Boundary + '--');

  try
    tHTTP.Post(frx_GoogleDrive_Upload_URL, MemoryStream);
  finally
    MemoryStream.Free;
  end;
end;

end.
