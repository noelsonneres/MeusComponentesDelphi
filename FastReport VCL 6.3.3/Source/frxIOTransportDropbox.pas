
{******************************************}
{                                          }
{              FastReport v6.0             }
{            Dropbox Save Filter           }
{                                          }
{          Copyright (c) 2016-2018         }
{             Fast Reports Inc.            }
{                                          }
{******************************************}

unit frxIOTransportDropbox;

interface

{$I frx.inc}

uses
  Classes, frxIOTransportDropboxBase, frxIOTransportHelpers,
  frxBaseTransportConnection;

type
{$IFDEF DELPHI16}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64)]
{$ENDIF}
  TfrxDropboxIOTransport = class(TfrxBaseDropboxIOTransport)
  protected
    function FolderAPI(const URL, Source: String): String; override;
    procedure Upload(const Source: TStream; DestFileName: String = ''); override;
    procedure Download(const SourceFileName: String; const Source: TStream); override;
  public
    function GetConnectorInstance: TfrxBaseTransportConnectionClass; override;
    procedure TestToken(const URL: String; var sToken: String; bUsePOST: Boolean = False); override;
  end;

implementation

uses
  SysUtils, frxJSON, frxTransportHTTP;

{ TfrxDropboxIOTransport }

procedure TfrxDropboxIOTransport.Download(const SourceFileName: String;
  const Source: TStream);
var
  FileName: String;
  THTTP: TfrxTransportHTTP;
begin
  inherited;
  THTTP := TfrxTransportHTTP(FHTTP);
  FileName := RemoteDir + SourceFileName;
  THTTP.HTTPRequest.Encoding := '';
  THTTP.HTTPRequest.DefAcceptTypes := htcDefaultXML;
  THTTP.HTTPRequest.ContentType := '';
  THTTP.HTTPRequest.CustomHeader.Add('Dropbox-API-Arg: ' + Format('{ "path": "%s"}',
        {$IfDef Delphi12}[JsonEncode(FileName)]));
        {$Else}          [AnsiToUtf8(FileName)]));
        {$EndIf}
  try
    THTTP.Get(FRX_DBOX_DL_URL, Source);
  finally
    THTTP.HTTPRequest.CustomHeader.Clear;
  end;
end;

function TfrxDropboxIOTransport.FolderAPI(const URL, Source: String): String;
var
  Stream: TStringStream;
  THTTP: TfrxTransportHTTP;
begin
  THTTP := TfrxTransportHTTP(FHTTP);
  THTTP.HTTPRequest.ContentType := 'application/json';
  THTTP.HTTPRequest.Encoding := 'UTF-8';
  Stream := TStringStream.Create(Source{$IfDef Delphi12}, TEncoding.UTF8{$EndIf});
  try
    Result := THTTP.Post(URL, Stream);
  finally
    Stream.Free;
  end;
end;

function TfrxDropboxIOTransport.GetConnectorInstance: TfrxBaseTransportConnectionClass;
begin
  Result := TfrxTransportHTTP;
end;

procedure TfrxDropboxIOTransport.TestToken(const URL: String;
  var sToken: String; bUsePOST: Boolean);
begin
  frxTestToken(URL, sToken, bUsePOST);
end;

procedure TfrxDropboxIOTransport.Upload(const Source: TStream;
  DestFileName: String);
var
  Res: String;
  FileName: String;
  THTTP: TfrxTransportHTTP;
begin
  inherited;
  FileName := RemoteDir + DestFileName;
  THTTP := TfrxTransportHTTP(FHTTP);
  THTTP.HTTPRequest.ContentType := 'application/octet-stream';
  THTTP.HTTPRequest.Encoding := '';
  try
    THTTP.HTTPRequest.CustomHeader.Add('Dropbox-API-Arg: ' +
      Format('{ "path": "%s", "mode": "overwrite"}',
        {$IfDef Delphi12}[JsonEncode(FileName)]));
        {$Else}          [AnsiToUtf8(FileName)]));
        {$EndIf}
    Res := THTTP.Post(FRX_DBOX_UL_URL, Source);
  finally
    THTTP.HTTPRequest.CustomHeader.Clear;
  end;
end;

end.
