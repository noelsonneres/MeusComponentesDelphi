
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

unit frxIOTransportBoxComIndy;

interface

{$I frx.inc}

uses
  Classes, Forms, Controls, StdCtrls, ComCtrls,
  frxIOTransportHelpers, frxIOTransportBoxComBase,
  frxBaseTransportConnection, IdHTTP, IdComponent;

type
{$IFDEF DELPHI16}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64)]
{$ENDIF}
  TfrxBoxComIOTransportIndy = class(TfrxBaseBoxComIOTransport)
  protected
    function GetListFolder: String; override;
    function GetListFolderContinue(Offset: Integer): String; override;
    procedure CreateFolder(Dir: String); override;
    procedure DeleteFile(Id: String); override;
    procedure DeleteFolder(Id: String); override;

    procedure Upload(const Source: TStream; DestFileName: String = '');
      override;
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

{ TfrxBoxComIOTransport }

procedure TfrxBoxComIOTransportIndy.CreateFolder(Dir: String);
var
  Stream: TStringStream;
  IdHTTP: TIdHTTP;
begin
  IdHTTP := TfrxTransportIndyConnectorHTTP(FHTTP).GetIdHTTP;
  IdHTTP.Request.ContentType := 'application/json';
  {$IfNDef Indy9}
  {$IfDef Delphi14}
  IdHTTP.Request.CharSet := 'UTF-8';
  {$EndIf}
  {$EndIf}

  Stream := TStringStream.Create(Format('{"name": "%s", "parent": {"id": "%s"}}',
    {$IfDef Delphi12}[Dir, FDirStack.Top]), TEncoding.UTF8);
    {$Else}          [JsonEncode(Dir), FDirStack.Top]));
    {$EndIf}

  try
    IdHTTP.Post(frx_BoxCom_CreateDir_URL, Stream);
  finally
    Stream.Free;
  end;
end;

procedure TfrxBoxComIOTransportIndy.DeleteFile(Id: String);
begin
// Indy 10.0 don't have TIdHTTP.Delete, Indy 10.6 have it
//  FHTTP.Delete(Format(URL, [Id]));
{$IfNDef Indy9}
{$IfNDef INDY10_1}
  TIdHTTPAccess(TfrxTransportIndyConnectorHTTP(FHTTP).GetIdHTTP)
    .DoRequest('DELETE', Format(frx_BoxCom_DelFile_URL, [Id]), nil, nil, []);
{$EndIf}
{$EndIf}
end;

procedure TfrxBoxComIOTransportIndy.DeleteFolder(Id: String);
begin
// Indy 10.0 don't have TIdHTTP.Delete, Indy 10.6 have it
//  FHTTP.Delete(Format(URL, [Id]));
{$IfNDef Indy9}
{$IfNDef INDY10_1}
  TIdHTTPAccess(TfrxTransportIndyConnectorHTTP(FHTTP).GetIdHTTP)
    .DoRequest('DELETE', Format(frx_BoxCom_DelDir_URL, [Id]), nil, nil, []);
{$EndIf}
{$EndIf}
end;

function TfrxBoxComIOTransportIndy.GetAccessToken(AuthorizationCode, ClientId,
  ClientSecret: String; var ErrorMsg: String): String;
var
  IdHttp: TIdHttp;
  Source: TStringStream;
  Res: String;
  frxJSON: TfrxJSON;
begin
  Source := TStringStream.Create('');
  Source.WriteString('grant_type=authorization_code&');
  Source.WriteString('code=' + AuthorizationCode + '&');
  Source.WriteString('client_id=' + ClientId + '&');
  Source.WriteString('client_secret=' + ClientSecret);
  try
    IdHTTP := TIdHTTP.Create(nil);
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
    try
      Res := IdHTTP.Post(frx_BoxCom_GetToken_URL, Source);
      frxJSON := TfrxJSON.Create(Res);
      try
        if      frxJSON.IsNameExists('access_token') then
          Result := frxJSON.ValueByName('access_token')
        else if frxJSON.IsNameValueExists('type', 'error') then
          ErrorMsg := 'Error: ' + frxJSON.ValueByName('status') + '; ' +
            frxJSON.ValueByName('message');
      finally
        frxJSON.Free;
      end;
    finally
      IdHTTP.Free;
    end;
  finally
    Source.Free;
  end;
end;

function TfrxBoxComIOTransportIndy.GetConnectorInstance: TfrxBaseTransportConnectionClass;
begin
  Result := TfrxTransportIndyConnectorHTTP;
end;

class function TfrxBoxComIOTransportIndy.GetDescription: String;
begin
  Result :=  '(Indy)' + inherited GetDescription;
end;

function TfrxBoxComIOTransportIndy.GetListFolder: String;
begin
  Result := TfrxTransportIndyConnectorHTTP(FHTTP).GetIdHTTP.Get(Format(frx_BoxCom_ListDir_URL, [FDirStack.Top]));
end;

function TfrxBoxComIOTransportIndy.GetListFolderContinue(Offset: Integer): String;
begin
  Result := TfrxTransportIndyConnectorHTTP(FHTTP).GetIdHTTP.Get(Format(frx_BoxCom_ListDirContinue_URL, [FDirStack.Top, Offset]));
end;

procedure TfrxBoxComIOTransportIndy.TestToken(const URL: String; var sToken: String;
  bUsePOST: Boolean);
begin
  frxTestTokenIndy(URL, sToken, bUsePOST);
end;

procedure TfrxBoxComIOTransportIndy.Upload(const Source: TStream;
  DestFileName: String);
var
  MultipartData: TIdMultipartFormDataStream;
  IdHTTP: TIdHTTP;
begin
  inherited;
  IdHTTP := TfrxTransportIndyConnectorHTTP(FHTTP).GetIdHTTP;
  MultipartData := TIdMultipartFormDataStream.Create;
  try
    MultipartData.AddFormField('metadata',
      Format('{"name": "%s", "parent": {"id": "%s"}}',
             [SureUTF8(DestFileName), FDirStack.Top])
    {$IfDef INDY10_1}
                   );
    {$Else}
    {$IfDef Indy9} );
    {$Else}        , 'utf-8', 'application/json').ContentTransfer := '8bit';
    {$EndIf}
    {$EndIf}
    //MultipartData.AddFile('content', SourceFileName, 'application/octet-stream');
{$IfDef Indy9}
    MultipartData.AddObject('content', 'application/octet-stream', Source, '');
{$Else}
{$IfDef INDY10_1}
{$IFDEF DELPHI15}
    MultipartData.AddObject('content', 'application/octet-stream', 'utf-8', Source, '');
{$ELSE}
    MultipartData.AddObject('content', 'application/octet-stream', Source, '');
{$EndIf}
{$Else}
    MultipartData.AddFormField('content', 'application/octet-stream', '', Source);
{$EndIf}
{$EndIf}
    IdHTTP.Post(frx_BoxCom_Upload_URL, MultipartData);
  finally
    MultipartData.Free;
  end;
end;

end.
