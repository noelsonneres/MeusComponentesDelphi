
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

unit frxIOTransportGoogleDriveIndy;

interface

{$I frx.inc}

uses
  Classes, Forms, Controls, StdCtrls, ComCtrls,
  frxIOTransportHelpers, frxIOTransportGoogleDriveBase,
  frxBaseTransportConnection, IdHTTP, IdComponent;

type
{$IFDEF DELPHI16}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64)]
{$ENDIF}
  TfrxGoogleDriveIOTransportIndy = class(TfrxBaseGoogleDriveIOTransport)
  protected
    function GetListFolder(aFilter: String = ''): String; override;
    function GetListFolderContinue(NextPageToken: String; aFilter: String = ''): String; override;
    procedure CreateFolder(Dir: String); override;
    procedure DeleteFileOrFolder(const Id: String); override;
    procedure Upload(const Source: TStream; DestFileName: String = ''); override;
    procedure Download(const SourceFileName: String; const Source: TStream); override;
  public
    function GetConnectorInstance: TfrxBaseTransportConnectionClass; override;
    class function GetDescription: String; override;
    function GetAccessToken(AuthorizationCode, ClientId, ClientSecret: String; var ErrorMsg: String): String; override;
    procedure TestToken(const URL: String; var sToken: String; bUsePOST: Boolean = False); override;
  end;

implementation

uses
  SysUtils, frxMapHelpers, frxRes, frxJSON, frxTransportIndyConnectorHTTP,
  IdSSLOpenSSL, Variants, StrUtils, IdURI, IdMultipartFormData;

type
  TIdHTTPAccess = class(TIdHTTP)
  end;

{ TfrxGoogleDriveIOTransport }

procedure TfrxGoogleDriveIOTransportIndy.CreateFolder(Dir: String);
var
  Stream: TStringStream;
  IdHTTP: TIdHTTP;
begin
  IdHTTP := TfrxTransportIndyConnectorHTTP(FHTTP).GetIdHTTP;
  IdHTTP.Request.ContentType := 'application/json';
{$IfNDef Indy9}
{$IfNDef INDY10_1}
  IdHTTP.Request.CharSet:='UTF-8';
{$EndIf}
{$EndIf}
  Stream := TStringStream.Create(
    Format('{"mimeType": "%s", "name": "%s", "parents": ["%s"]}',
    {$IfDef Delphi12}[frx_GoogleDrive_MimeFolder, Dir, FDirStack.Top]), TEncoding.UTF8);
    {$Else}          [frx_GoogleDrive_MimeFolder, JsonEncode(Dir), FDirStack.Top]));
    {$EndIf}

  try
    IdHTTP.Post(frx_GoogleDrive_CreateDir_URL, Stream);
  finally
    Stream.Free;
  end;
end;

procedure TfrxGoogleDriveIOTransportIndy.DeleteFileOrFolder(const Id: String);
begin
// Indy 10.0 don't have TIdHTTP.Delete, Indy 10.6 have it
//  FHTTP.Delete(Format(URL, [Id]));
{$IfNDef Indy9}
{$IfNDef INDY10_1}
  TIdHTTPAccess(TfrxTransportIndyConnectorHTTP(FHTTP).GetIdHTTP)
    .DoRequest('DELETE', Format(frx_GoogleDrive_Delete_URL, [Id]), nil,
    nil, []);
{$EndIf}
{$EndIf}
end;

procedure TfrxGoogleDriveIOTransportIndy.Download(const SourceFileName: String;
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
    TfrxTransportIndyConnectorHTTP(FHTTP).GetIdHTTP.Get(Format(frx_GoogleDrive_Download_URL, [sID]), Source);
  finally
    ClearWithObjects(SList);
    SList.Free;
  end;
end;

function TfrxGoogleDriveIOTransportIndy.GetAccessToken(AuthorizationCode, ClientId,
  ClientSecret: String; var ErrorMsg: String): String;
var
  IdHTTP: TIdHTTP;
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
    IdHttp := TIdHttp.Create(nil);
    try
{$IFDEF Indy9}
      IdHTTP.IOHandler := TIdSSLIOHandlerSocket.Create(IdHTTP);
      TIdSSLIOHandlerSocket(IdHTTP.IOHandler).SSLOptions.Method := sslvTLSv1;
      IdHTTP.Request.CustomHeaders.FoldLength := MaxInt;
{$ELSE}
      IdHTTP.IOHandler := TIdSSLIOHandlerSocketOpenSSL.Create(IdHTTP);
{$ENDIF}
      IdHTTP.Request.BasicAuthentication := False;
      IdHTTP.Request.Accept := 'text/html,application/xhtml+xml,application/xml;q=0.9';
      IdHTTP.Request.ContentType := 'application/x-www-form-urlencoded';
      Res := IdHttp.Post(frx_GoogleDrive_GetToken_URL, Source);
      frxJSON := TfrxJSON.Create(Res);
      try
        if frxJSON.IsNameExists('access_token') then
          Result := frxJSON.ValueByName('access_token')
        else if frxJSON.IsNameValueExists('type', 'error') then
          ErrorMsg := 'Error: ' + frxJSON.ValueByName('status') + '; ' +
            frxJSON.ValueByName('message');
      finally
        frxJSON.Free;
      end;
    finally
      IdHttp.Free;
    end;
  finally
    Source.Free;
  end;
end;

function TfrxGoogleDriveIOTransportIndy.GetConnectorInstance: TfrxBaseTransportConnectionClass;
begin
  Result := TfrxTransportIndyConnectorHTTP;
end;

class function TfrxGoogleDriveIOTransportIndy.GetDescription: String;
begin
  Result :=  '(Indy)' + inherited GetDescription;
end;

function TfrxGoogleDriveIOTransportIndy.GetListFolder(aFilter: String): String;
begin
  if aFilter <> '' then
    aFilter := Format('+and+name=''%s''', [aFilter]);
  Result := TfrxTransportIndyConnectorHTTP(FHTTP)
    .GetIdHTTP.Get(Format(frx_GoogleDrive_ListDir_URL, [FDirStack.Top, aFilter]));
end;

function TfrxGoogleDriveIOTransportIndy.GetListFolderContinue(NextPageToken: String; aFilter: String): String;
begin
  if aFilter <> '' then
    aFilter := Format('+and+name=''%s''', [aFilter]);
  Result := TfrxTransportIndyConnectorHTTP(FHTTP)
    .GetIdHTTP.Get(Format(frx_GoogleDrive_ListDirContinue_URL, [FDirStack.Top, aFilter, NextPageToken]));
end;

procedure TfrxGoogleDriveIOTransportIndy.TestToken(const URL: String;
  var sToken: String; bUsePOST: Boolean);
begin
  frxTestTokenIndy(URL, sToken, bUsePOST);
end;

procedure TfrxGoogleDriveIOTransportIndy.Upload(const Source: TStream;
  DestFileName: String);
const
  Boundary = '560310243403';
var
  MemoryStream: TMemoryStream;
  IdHTTP: TIdHTTP;

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
  IdHTTP := TfrxTransportIndyConnectorHTTP(FHTTP).GetIdHTTP;
  idHTTP.Request.ContentType :=
    Format('multipart/related; boundary="%s"', [Boundary]);
{$IfNDef Indy9}
{$IfNDef INDY10_1}
  idHTTP.Request.CharSet:='';
{$EndIf}
{$EndIf}

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
    idHTTP.Post(frx_GoogleDrive_Upload_URL, MemoryStream);
  finally
    MemoryStream.Free;
  end;
end;

end.
