
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

unit frxIOTransportOneDriveIndy;

interface

{$I frx.inc}

uses
  Classes, Forms, Controls, StdCtrls, ComCtrls,
  frxIOTransportHelpers, frxIOTransportOneDriveBase,
  frxBaseTransportConnection, IdHTTP, IdComponent;

type
{$IFDEF DELPHI16}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64)]
{$ENDIF}
  TfrxOneDriveIOTransportIndy = class(TfrxBaseOneDriveIOTransport)
  protected
    function GetListFolder: String; override;
    function GetListFolderContinue(NextLink: String): String; override;
    procedure CreateFolder(Dir: String); override;
    procedure DeleteFileOrFolder(Name: String); override;
    procedure Upload(const Source: TStream; DestFileName: String = '');
      override;
    procedure Download(const SourceFileName: String; const Source: TStream); override;
  public
    function GetConnectorInstance: TfrxBaseTransportConnectionClass; override;
    class function GetDescription: String; override;
    procedure TestToken(const URL: String; var sToken: String; bUsePOST: Boolean = False); override;
  end;

implementation

uses
  SysUtils, frxMapHelpers, frxRes, frxJSON, frxTransportIndyConnectorHTTP,
  IdSSLOpenSSL, Variants, StrUtils, IdURI;

type
  TIdHTTPAccess = class(TIdHTTP);
{ TfrxOneDriveIOTransport }

procedure TfrxOneDriveIOTransportIndy.CreateFolder(Dir: String);
var
  Stream: TStringStream;
  IdHTTP: TIdHTTP;
begin
  IdHTTP := TfrxTransportIndyConnectorHTTP(FHTTP).GetIdHTTP;
  IdHTTP.Request.ContentType := 'application/json';
  {$IfNDef Indy9}
  {$IfDef Delphi14}
  IdHTTP.Request.CharSet:='UTF-8';
  {$EndIf}
  {$EndIf}

  Stream := TStringStream.Create(Format('{ "name": "%s", "folder": { } }',
    {$IfDef Delphi12}[(Dir)]), TEncoding.UTF8);
    {$Else}          [JsonEncode(Dir)]));
    {$EndIf}

  try
  {$IfDef Indy9}
    try
  {$EndIf}
      IdHTTP.Post(TIdURI.URLEncode(Format(frx_OneD_CreateDir_URL, [SureUTF8(RemoteDir)])), Stream);
  {$IfDef Indy9}
    except
      on E: EIdHTTPProtocolException do
        if (not IdHTTP.HandleRedirects and (E.ReplyErrorCode = 201))
            or (IdHTTP.HandleRedirects and (E.ReplyErrorCode = 404)) then
          raise EIdHTTPProtocolException.Create(E.ErrorMessage);
    end;
  {$EndIf}
  finally
    Stream.Free;
  end;
end;

procedure TfrxOneDriveIOTransportIndy.DeleteFileOrFolder(Name: String);
begin
// Indy 10.0 don't have TIdHTTP.Delete, Indy 10.6 have it
//  FHTTP.Delete(Format(URL, [Id]));

// http://stackoverflow.com/questions/21002337/how-to-send-a-delete-request-with-indy
// http://stackoverflow.com/questions/42772919/how-to-send-a-delete-request-with-indy-9
{$IfNDef Indy9}
{$IfNDef INDY10_1}
  TIdHTTPAccess(TfrxTransportIndyConnectorHTTP(FHTTP).GetIdHTTP).DoRequest('DELETE',
    TIdURI.URLEncode(Format(frx_OneD_DEL_URL, [SureUTF8(RemoteDir + '/' + Name)])), nil, nil, []);
{$EndIf}
{$EndIf}
end;

procedure TfrxOneDriveIOTransportIndy.Download(const SourceFileName: String;
  const Source: TStream);
var
  DlLink: String;
  IdHTTP: TIdHTTP;
begin
  inherited;
  IdHTTP := TfrxTransportIndyConnectorHTTP(FHTTP).GetIdHTTP;
  DlLink := '';
  IdHTTP.Request.ContentType := 'application/octet-stream';
  try
    try
      IdHTTP.Get(TIdURI.URLEncode(Format(frx_OneD_DL_URL, [SureUTF8(RemoteDir),
        SureUTF8(SourceFileName)])), Source);
    except
      on E: EIdHTTPProtocolException do
{$IfDef Indy9}
        if (E.ReplyErrorCode <> 302) then
{$ELSE}
        if (E.ErrorCode <> 302) then
{$ENDIF}
          raise EIdHTTPProtocolException.Create(E.ErrorMessage);
    end;
  finally
    if IdHTTP.Response.ResponseCode = 302 then
      DlLink := IdHTTP.Response.Location;
    if DlLink <> '' then
      IdHTTP.Get(DlLink, Source);
  end;
end;

function TfrxOneDriveIOTransportIndy.GetConnectorInstance: TfrxBaseTransportConnectionClass;
begin
  Result := TfrxTransportIndyConnectorHTTP;
end;

class function TfrxOneDriveIOTransportIndy.GetDescription: String;
begin
  Result :=  '(Indy)' + inherited GetDescription;
end;

function TfrxOneDriveIOTransportIndy.GetListFolder: String;
begin
  Result := TfrxTransportIndyConnectorHTTP(FHTTP)
    .GetIdHTTP.Get(Format(frx_OneD_LF_URL, [TIdURI.PathEncode(SureUTF8(RemoteDir))]));
end;

function TfrxOneDriveIOTransportIndy.GetListFolderContinue(NextLink: String): String;
begin
  Result := TfrxTransportIndyConnectorHTTP(FHTTP).GetIdHTTP.Get(NextLink);
end;

procedure TfrxOneDriveIOTransportIndy.TestToken(const URL: String;
  var sToken: String; bUsePOST: Boolean);
begin
  frxTestTokenIndy(URL, sToken, bUsePOST);
end;

procedure TfrxOneDriveIOTransportIndy.Upload(const Source: TStream;
  DestFileName: String);
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
  IdHTTP.Request.ContentType :=
    Format('multipart/related; boundary="%s"', [FRX_OneD_Boundary]);
  {$IfNDef Indy9}
  {$IfNDef INDY10_1}
  IdHTTP.Request.CharSet:='';
  {$EndIf}
  {$EndIf}
  MemoryStream := TMemoryStream.Create;

  PutLn('--' + FRX_OneD_Boundary);
  PutLn('Content-ID: <metadata>');
  PutLn('Content-Type: application/json');
  PutLn;

  PutLn(SureAnsi(Format(
    '{ "name": "%s", "file": {}, "@content.sourceUrl": "cid:content" }',
    [SureUTF8(DestFileName)])));
  PutLn('--' + FRX_OneD_Boundary);
  PutLn('Content-ID: <content>');
  PutLn('Content-Type: application/octet-stream');
  PutLn;
  MemoryStream.CopyFrom(Source, Source.Size);

  PutLn;
  Put('--' + frx_OneD_Boundary + '--');

  try
  {$IfDef Indy9}
    try
  {$EndIf}
   IdHTTP.Post(TIdURI.URLEncode(Format(FRX_OneD_UP_URL, [SureUTF8(RemoteDir)])), MemoryStream);
  {$IfDef Indy9}
    except
      on E: EIdHTTPProtocolException do
        if (not IdHTTP.HandleRedirects and (E.ReplyErrorCode = 201))
            or (IdHTTP.HandleRedirects and (E.ReplyErrorCode = 404)) then
          raise EIdHTTPProtocolException.Create(E.ErrorMessage);
    end;
  {$EndIf}
  finally
    MemoryStream.Free;
  end;
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
