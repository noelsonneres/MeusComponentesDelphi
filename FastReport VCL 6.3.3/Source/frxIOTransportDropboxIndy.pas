
{******************************************}
{                                          }
{              FastReport v6.0             }
{          Dropbox(Indy) Save Filter       }
{                                          }
{          Copyright (c) 2016-2017         }
{             by Oleg Adibekov,            }
{             Fast Reports Inc.            }
{                                          }
{******************************************}

unit frxIOTransportDropboxIndy;

interface

{$I frx.inc}

uses
  Classes, frxIOTransportDropboxBase, frxIOTransportHelpers,
  frxBaseTransportConnection, IdHTTP, IdComponent;

type
{$IFDEF DELPHI16}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64)]
{$ENDIF}
  TfrxDropboxIOTransportIndy = class(TfrxBaseDropboxIOTransport)
  protected
    function FolderAPI(const URL, Source: String): String; override;
    procedure Upload(const Source: TStream; DestFileName: String = ''); override;
    procedure Download(const SourceFileName: String; const Source: TStream); override;
  public
    function GetConnectorInstance: TfrxBaseTransportConnectionClass; override;
    class function GetDescription: String; override;
    procedure TestToken(const URL: String; var sToken: String; bUsePOST: Boolean = False); override;
  end;

implementation

uses
  SysUtils, frxMapHelpers, frxRes, frxJSON, frxTransportIndyConnectorHTTP,
  IdSSLOpenSSL, Variants, StrUtils;

{ TfrxDropboxIOTransport }

procedure TfrxDropboxIOTransportIndy.Download(const SourceFileName: String;
  const Source: TStream);
var
  FileName: String;
  IdHTTP: TIdHTTP;
begin
  inherited;
  IdHTTP := TfrxTransportIndyConnectorHTTP(FHTTP).GetIdHTTP;
  IdHTTP.Request.ContentType := '';
{$IfNDef Indy9}
{$IfNDef INDY10_1}
  IdHTTP.Request.CharSet:='';
{$EndIf}
{$EndIf}
  FileName := RemoteDir + SourceFileName;
  try
    IdHTTP.Request.CustomHeaders.Values['Dropbox-API-Arg'] :=
      Format('{ "path": "%s"}',
        {$IfDef Delphi12}[JsonEncode(FileName)]);
        {$Else}          [AnsiToUtf8(FileName)]);
        {$EndIf}
   IdHTTP.Get(FRX_DBOX_DL_URL, Source);
  finally
  end;
end;

function TfrxDropboxIOTransportIndy.FolderAPI(const URL, Source: String): String;
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

  Stream := TStringStream.Create(Source{$IfDef Delphi12}, TEncoding.UTF8{$EndIf});
  try
    Result := IdHTTP.Post(URL, Stream);
  finally
    Stream.Free;
  end;
end;

function TfrxDropboxIOTransportIndy.GetConnectorInstance: TfrxBaseTransportConnectionClass;
begin
  Result := TfrxTransportIndyConnectorHTTP;
end;

class function TfrxDropboxIOTransportIndy.GetDescription: String;
begin
  Result :=  '(Indy)' + inherited GetDescription;
end;

procedure TfrxDropboxIOTransportIndy.TestToken(const URL: String;
  var sToken: String; bUsePOST: Boolean);
begin
  frxTestTokenIndy(URL, sToken, bUsePOST);
end;

procedure TfrxDropboxIOTransportIndy.Upload(const Source: TStream;
  DestFileName: String);
var
  Res: String;
  FileName: String;
  IdHTTP: TIdHTTP;
begin
  inherited;
  IdHTTP := TfrxTransportIndyConnectorHTTP(FHTTP).GetIdHTTP;
  IdHTTP.Request.ContentType := 'application/octet-stream';
{$IfNDef Indy9}
{$IfNDef INDY10_1}
  IdHTTP.Request.CharSet:='';
{$EndIf}
{$EndIf}

  FileName := RemoteDir + DestFileName;
  IdHTTP.Request.CustomHeaders.Values['Dropbox-API-Arg'] :=
      Format('{ "path": "%s", "mode": "overwrite"}',
        {$IfDef Delphi12}[JsonEncode(FileName)]);
        {$Else}          [AnsiToUtf8(FileName)]);
        {$EndIf}
  Res := IdHTTP.Post(FRX_DBOX_UL_URL, Source);
end;

end.
